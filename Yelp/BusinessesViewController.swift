//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, SearchViewControllerDelegate {

    // MARK: - Properties
    var businesses: [Business]!
    @IBOutlet weak var businessTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var businessSearchTerm: String? {
        get {
            return searchBar?.text
        }
        set(newValue) {
            searchBar?.text = newValue
            loadResultsForBusinessTable(true)
        }
    }

    var listingsRefreshControl: UIRefreshControl!
    var deviceLocation: CLLocation?
    var currentLocation: CLLocation {
        return deviceLocation ?? ViewConstants.DefaultLocation
    }

    struct ViewConstants {
        static let DefaultSearchTerm = "Restaurants"
        static let BusinessCellEstimatedHeight = CGFloat(150)
        static let DefaultLocation = CLLocation(latitude: CLLocationDegrees(37.7873589), longitude: CLLocationDegrees(-122.408227))
        static let RowIndexDiffThresholdForTrigger = 5
    }

    private var searchBarTextField: UITextField? {
        return searchBar?.valueForKey("searchField") as? UITextField
    }

    var userSetFilters: [YelpFilters]?
    private var searchFilters: [YelpFilters] {
        return userSetFilters ?? [YelpDealsFilter(), YelpSortFilter(), YelpDistanceFilter()]
    }

    let locationManager = CLLocationManager()

    struct InfiniteScrolling {
        var nextOffsetToLoad = 0
        var hasMoreResults = true

        mutating func resetParameters() {
            nextOffsetToLoad = 0
            hasMoreResults = true
        }
    }

    var infScrolling = InfiniteScrolling()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()

        // View setup
        setupSearchBar()
        setupBusinessTableView()
        businessSearchTerm = ViewConstants.DefaultSearchTerm
    }

    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Table View Delegate and DataSource methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let businessCell = businessTableView.dequeueReusableCellWithIdentifier(BusinessVCCellIdentifiers.BusinessCell.rawValue, forIndexPath: indexPath) as! BusinessTableViewCell
        businessCell.business = businesses[indexPath.row]
        return businessCell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        businessTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ViewConstants.BusinessCellEstimatedHeight
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if infScrolling.hasMoreResults && (infScrolling.nextOffsetToLoad - indexPath.row) == ViewConstants.RowIndexDiffThresholdForTrigger {
            print("Calling additional load at row \(indexPath.row)")
            loadResultsForBusinessTable(false)
        }
    }
    // MARK: - Location Manager delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            deviceLocation = location
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(error.localizedDescription)")
        deviceLocation = nil
    }

    // MARK: - Search VC delegate methods
    func searchViewController(searchViewController: SearchViewController, didSetFilters filters: [YelpFilters]) {
        userSetFilters = filters
        infScrolling.resetParameters()
        loadResultsForBusinessTable(true)
    }

    // MARK: - UISearchBar delegate methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        infScrolling.resetParameters()
        loadResultsForBusinessTable(true)
    }

    // MARK: - View Actions
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        infScrolling.resetParameters()
        loadResultsForBusinessTable(true)
    }

    // MARK: - Internal Methods
    private func setupBusinessTableView() {
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = ViewConstants.BusinessCellEstimatedHeight

        listingsRefreshControl = UIRefreshControl()
        listingsRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        businessTableView.addSubview(listingsRefreshControl)
    }

    private func setupSearchBar() {
        // change  the color of the text
        searchBarTextField?.textColor = UIColor.whiteColor()
        searchBar.delegate = self
    }

    private func loadResultsForBusinessTable(showActivitity: Bool) {
        showActivitity ? listingsRefreshControl.beginRefreshing() : ()
        let searchTerm = businessSearchTerm ?? ViewConstants.DefaultSearchTerm

        Business.searchWithTerm(searchTerm, location: currentLocation, filters: searchFilters, offset: infScrolling.nextOffsetToLoad) { (businesses: [Business]!, error: NSError!) -> Void in

            print("Offset >>> \(self.infScrolling.nextOffsetToLoad) Count returned >>>> \(businesses.count)")
    
            if self.infScrolling.nextOffsetToLoad == 0 {
                self.businesses = businesses
            } else {
                self.businesses.appendContentsOf(businesses)
            }

            for b in businesses {
                print(b.name!)
            }
            


            self.infScrolling.nextOffsetToLoad += businesses.count
            self.infScrolling.hasMoreResults = businesses.count < YelpClient.LimitPerRequest ? false : true
            self.businessTableView.reloadData()
            self.listingsRefreshControl.endRefreshing()
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navController = segue.destinationViewController as? UINavigationController {
            if let searchVC = navController.topViewController as? SearchViewController {
                userSetFilters = nil
                searchVC.delegate = self
            }
            
        } else if let detailsVC = segue.destinationViewController as? BusinessDetailsViewController {
            let indexPath = businessTableView.indexPathForCell((sender as! BusinessTableViewCell))
            detailsVC.business = self.businesses[(indexPath?.row)!]
        }
    }


}

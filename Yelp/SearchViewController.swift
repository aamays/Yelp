//
//  SearchViewController.swift
//  Yelp
//
//  Created by Amay Singhal on 9/23/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTableView: UITableView!

    let filterLayout = FiltersLayout.filters

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Delegate and Data Source methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterLayout.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterLayout[section][FiltersLayout.SectionName] as? String
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterLayout[section][FiltersLayout.Options]?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterCell = searchTableView.dequeueReusableCellWithIdentifier(YMainStoryboard.FilterTableCellIdentifier, forIndexPath: indexPath) as! FilterTableViewCell

        // get filter option for the row
        let options = filterLayout[indexPath.section][FiltersLayout.Options] as! NSArray
        filterCell.filterNameLabel.text = options[indexPath.row] as? String
        return filterCell
    }

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchButtonTapped(sender: UIBarButtonItem) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

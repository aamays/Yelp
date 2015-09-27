//
//  SearchViewController.swift
//  Yelp
//
//  Created by Amay Singhal on 9/23/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SearchViewControllerDelegate: class {
    optional func initialFilters() -> [YelpFilters]
    optional func searchViewController(searchViewController: SearchViewController, didSetFilters filters: [YelpFilters])
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterTableViewCellDelegate {

    @IBOutlet weak var searchTableView: UITableView!

    weak var delegate: SearchViewControllerDelegate?

    var yelpFilters = [YelpDealsFilter(), YelpDistanceFilter(), YelpSortFilter(), YelpCategoryFilter()]

    struct ViewConfig {
        static let SelectionCellShowAllText = "Show All"
        static let SelectionCellShowLessText = "Show Less"
    }

    // MARK: - View Lifecycle Methods
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
        return yelpFilters.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return yelpFilters[section].filterSectionName
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let yelpFilter = yelpFilters[section]
        return yelpFilter.numberOfRows
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get filter option for the row
        let yelpFilter = yelpFilters[indexPath.section]

        var cellIndetifier = SearchVCCellIdentifiers.FilterTableViewCell
        if (yelpFilter as? YelpCategoryFilter) != nil && indexPath.row == (yelpFilter.numberOfRows - 1) && !yelpFilter.isExpanded {
            cellIndetifier = SearchVCCellIdentifiers.ShowSelectionTableViewCell
        } else {
            cellIndetifier = yelpFilter.isExpandable && yelpFilter.isExpanded ? yelpFilter.expandedCellIdentifier : yelpFilter.collapsedCellIdentifier
        }

        switch cellIndetifier {
        case .FilterTableViewCell:
            let filterCell = getDequeuedFilterCell(indexPath)
            let index = indexPath.row
            filterCell.filterNameLabel.text = yelpFilter.expandedOptions[index][YelpFilters.DisplayName] as? String
            filterCell.filterSwitch.on = yelpFilter.selectedOptions.contains(index)
            filterCell.delegate = self
            return filterCell
        case .PreviewTableViewCell:
            let previewCell = getDequeuedPreviewCell(indexPath)
            previewCell.tag = indexPath.section
            if yelpFilter.isExpanded {
                previewCell.previewFilterNameLabel.text = yelpFilter.expandedOptions[indexPath.row][YelpFilters.DisplayName] as? String
                previewCell.cellState = yelpFilter.selectedOptions.contains(indexPath.row) ? PreviewTableViewCell.CellState.Checked : PreviewTableViewCell.CellState.Unchecked
            } else {
                previewCell.cellState = PreviewTableViewCell.CellState.Collapsed
                previewCell.previewFilterNameLabel.text = yelpFilter.expandedOptions[yelpFilter.selectedOptions[indexPath.row]][YelpFilters.DisplayName] as? String
            }
            return previewCell
        case .ShowSelectionTableViewCell:
            let selectionCell = getDequeuedSelectionCell(indexPath)
            selectionCell.showSelectionLabel.text = yelpFilter.isExpanded ? ViewConfig.SelectionCellShowLessText : ViewConfig.SelectionCellShowAllText
            return selectionCell
        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let selectedCell = searchTableView.cellForRowAtIndexPath(indexPath) as? PreviewTableViewCell {
            previewCellTapped(selectedCell, forIndexPath: indexPath)
        } else if let selectedCell = searchTableView.cellForRowAtIndexPath(indexPath) as? ShowSelectionTableViewCell {
            showSelectionCellTapped(selectedCell, forIndexPath: indexPath)
        }
        searchTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - FilterCellView Delegate Method
    func filterCellSwitchDidToggle(cell: FilterTableViewCell, newValue: Bool) {

        let indexPath = searchTableView.indexPathForCell(cell)
        if newValue {
            yelpFilters[(indexPath?.section)!].selectedOptions.append((indexPath?.row)!)
            yelpFilters[(indexPath?.section)!].selectedOptions.sortInPlace()
        } else {
            yelpFilters[(indexPath?.section)!].selectedOptions = yelpFilters[(indexPath?.section)!].selectedOptions.filter { $0 != indexPath?.row }
        }
    }

    // MARK: - View actions methods
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchButtonTapped(sender: UIBarButtonItem) {
        delegate?.searchViewController?(self, didSetFilters: yelpFilters)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Helper functions
    private func getDequeuedPreviewCell(indexPath: NSIndexPath) -> PreviewTableViewCell {
        return searchTableView.dequeueReusableCellWithIdentifier(SearchVCCellIdentifiers.PreviewTableViewCell.rawValue, forIndexPath: indexPath) as! PreviewTableViewCell
    }

    private func getDequeuedFilterCell(indexPath: NSIndexPath) -> FilterTableViewCell {
        return searchTableView.dequeueReusableCellWithIdentifier(SearchVCCellIdentifiers.FilterTableViewCell.rawValue, forIndexPath: indexPath) as! FilterTableViewCell
    }

    private func getDequeuedSelectionCell(indexPath: NSIndexPath) -> ShowSelectionTableViewCell {
        return searchTableView.dequeueReusableCellWithIdentifier(SearchVCCellIdentifiers.ShowSelectionTableViewCell.rawValue, forIndexPath: indexPath) as! ShowSelectionTableViewCell
    }

    private func previewCellTapped(sender: PreviewTableViewCell, forIndexPath indexPath: NSIndexPath) {

        let section = indexPath.section

        if yelpFilters[section].isExpanded {
            if yelpFilters[section].selectedOptions.count > 0 {
                let prevCell = searchTableView.cellForRowAtIndexPath(NSIndexPath(forRow: yelpFilters[section].selectedOptions[0], inSection: section)) as? PreviewTableViewCell
                prevCell?.cellState = PreviewTableViewCell.CellState.Unchecked
                yelpFilters[section].selectedOptions[0] = indexPath.row
            } else {
                yelpFilters[section].selectedOptions.append(indexPath.row)
            }
            sender.cellState = PreviewTableViewCell.CellState.Checked
        }

        yelpFilters[section].isExpanded = !(yelpFilters[section].isExpanded)
        searchTableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    }

    private func showSelectionCellTapped(sender: ShowSelectionTableViewCell, forIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        yelpFilters[section].isExpanded = !(yelpFilters[section].isExpanded)
        searchTableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    }

}

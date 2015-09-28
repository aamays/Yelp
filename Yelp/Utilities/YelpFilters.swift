//
//  YelpFilters.swift
//  Yelp
//
//  Created by Amay Singhal on 9/25/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import Foundation


class YelpFilters: NSObject {
    // @todo: need to replace base class with protocol

    static let DisplayName = "name"
    static let FilterCode = "code"
    

    var filterSectionName: String!
    var isExpandable = false
    var isExpanded = false
    var collapsedCellIdentifier = SearchVCCellIdentifiers.PreviewTableViewCell
    var expandedCellIdentifier = SearchVCCellIdentifiers.FilterTableViewCell
    var selectedOptions = [Int]()
    var expandedOptions = [[String: AnyObject]]()
    var apiKey = ""
    var numberOfRows: Int {
        var rows = 0
        if !isExpandable || (isExpandable && isExpanded) {
            rows = expandedOptions.count
        } else {
            rows = selectedOptions.count
        }
        return rows
    }

    func getFilterValue() -> [String: AnyObject] {
        return ["values": selectedOptions]
    }
}

protocol YelpSearchFilter: class {

    static var apiKey: String {get}
    static var isExpandable: Bool {get}
    static var filterSectionName: String {get}
    static var collapsedCellIdentifier: SearchVCCellIdentifiers {get}
    static var expandedCellIdentifier: SearchVCCellIdentifiers {get}
    static var expandedOptions: [[String: AnyObject]] {get}

    var isExpanded: Bool {get set}
    var selectedOptions: [Int] {get set}

    func numberOfRows() -> Int
    func getFilterValue() -> [String: AnyObject]
}

class YelpDealsFilter: YelpFilters {

    override init() {
        super.init()

        filterSectionName = ""
        isExpandable = false
        apiKey = "deals_filter"
        expandedOptions = [[YelpFilters.DisplayName: "Offering a Deal", YelpFilters.FilterCode: ""]]
        selectedOptions = []
        collapsedCellIdentifier = SearchVCCellIdentifiers.FilterTableViewCell
        expandedCellIdentifier = SearchVCCellIdentifiers.FilterTableViewCell
    }

    override func getFilterValue() -> [String: AnyObject] {
        return [apiKey: selectedOptions.count != 0]
    }
}

class YelpDistanceFilter: YelpFilters {

    override init() {
        super.init()
        apiKey = "radius_filter"
        filterSectionName = "Distance"
        isExpandable = true
        expandedOptions = [[YelpFilters.DisplayName: "Auto", YelpFilters.FilterCode: 4800], // ~ 3 miles (not sure what default distance does real Yelp app use)
                           [YelpFilters.DisplayName: "0.3 miles", YelpFilters.FilterCode: 480],
                           [YelpFilters.DisplayName: "1 mile", YelpFilters.FilterCode: 1600],
                           [YelpFilters.DisplayName: "5 miles", YelpFilters.FilterCode: 8000],
                           [YelpFilters.DisplayName: "20 miles", YelpFilters.FilterCode: 32000]]
        selectedOptions = [0]
        collapsedCellIdentifier = SearchVCCellIdentifiers.PreviewTableViewCell
        expandedCellIdentifier = SearchVCCellIdentifiers.PreviewTableViewCell

    }

    override func getFilterValue() -> [String: AnyObject] {
        return [apiKey: expandedOptions[selectedOptions.first!][YelpFilters.FilterCode] as! Int]
    }
}


class YelpSortFilter: YelpFilters {

    override init() {
        super.init()
        apiKey = "sort"
        filterSectionName = "Sort by"
        isExpandable = true

        expandedOptions = [[YelpFilters.DisplayName: "Best Match", YelpFilters.FilterCode: YelpSortMode.BestMatched.rawValue],
                           [YelpFilters.DisplayName: "Distance", YelpFilters.FilterCode: YelpSortMode.Distance.rawValue],
                           [YelpFilters.DisplayName: "Rating", YelpFilters.FilterCode: YelpSortMode.HighestRated.rawValue]]
                        // [YelpFilters.DisplayName: "Most Reviewed", YelpFilters.FilterCode: ""] - Filter not available in API
        selectedOptions = [0]
        collapsedCellIdentifier = SearchVCCellIdentifiers.PreviewTableViewCell
        expandedCellIdentifier = SearchVCCellIdentifiers.PreviewTableViewCell
    }

    override func getFilterValue() -> [String: AnyObject] {
        return [apiKey: expandedOptions[selectedOptions.first!][YelpFilters.FilterCode] as! Int ]
    }
}

class YelpCategoryFilter: YelpFilters {

    override var numberOfRows: Int {
        var rows = 0
        if isExpanded {
            rows = expandedOptions.count
        } else {
            rows = 4
        }
        return rows
    }

    override init() {
        super.init()
        apiKey = "category_filter"
        filterSectionName = "Category"
        isExpandable = true
        selectedOptions = []

        collapsedCellIdentifier = SearchVCCellIdentifiers.FilterTableViewCell
        expandedCellIdentifier = SearchVCCellIdentifiers.FilterTableViewCell
        expandedOptions = [[YelpFilters.DisplayName : "American, New", YelpFilters.FilterCode: "newamerican"],
            [YelpFilters.DisplayName : "Baguettes", YelpFilters.FilterCode: "baguettes"],
            [YelpFilters.DisplayName : "Beer Garden", YelpFilters.FilterCode: "beergarden"],
            [YelpFilters.DisplayName : "Bistros", YelpFilters.FilterCode: "bistros"],
            [YelpFilters.DisplayName : "Breakfast & Brunch", YelpFilters.FilterCode: "breakfast_brunch"],
            [YelpFilters.DisplayName : "Burgers", YelpFilters.FilterCode: "burgers"],
            [YelpFilters.DisplayName : "Cafes", YelpFilters.FilterCode: "cafes"],
            [YelpFilters.DisplayName : "Chinese", YelpFilters.FilterCode: "chinese"],
            [YelpFilters.DisplayName : "Comfort Food", YelpFilters.FilterCode: "comfortfood"],
            [YelpFilters.DisplayName : "Fast Food", YelpFilters.FilterCode: "hotdogs"],
            [YelpFilters.DisplayName : "Food Court", YelpFilters.FilterCode: "food_court"],
            [YelpFilters.DisplayName : "Greek", YelpFilters.FilterCode: "greek"],
            [YelpFilters.DisplayName : "Indian", YelpFilters.FilterCode: "indpak"],
            [YelpFilters.DisplayName : "Japanese", YelpFilters.FilterCode: "japanese"],
            [YelpFilters.DisplayName : "Kebab", YelpFilters.FilterCode: "kebab"],
            [YelpFilters.DisplayName : "Korean", YelpFilters.FilterCode: "korean"],
            [YelpFilters.DisplayName : "Malaysian", YelpFilters.FilterCode: "malaysian"],
            [YelpFilters.DisplayName : "Mediterranean", YelpFilters.FilterCode: "mediterranean"],
            [YelpFilters.DisplayName : "Mexican", YelpFilters.FilterCode: "mexican"],
            [YelpFilters.DisplayName : "Pizza", YelpFilters.FilterCode: "pizza"],
            [YelpFilters.DisplayName : "Salad", YelpFilters.FilterCode: "salad"],
            [YelpFilters.DisplayName : "Sandwiches", YelpFilters.FilterCode: "sandwiches"],
            [YelpFilters.DisplayName : "Seafood", YelpFilters.FilterCode: "seafood"],
            [YelpFilters.DisplayName : "Tapas Bars", YelpFilters.FilterCode: "tapas"],
            [YelpFilters.DisplayName : "Vegan", YelpFilters.FilterCode: "vegan"],
            [YelpFilters.DisplayName : "Vegetarian", YelpFilters.FilterCode: "vegetarian"],
            [YelpFilters.DisplayName : "Wraps", YelpFilters.FilterCode: "wraps"]]
    }

    override func getFilterValue() -> [String: AnyObject] {
        return [apiKey: selectedOptions.map({ expandedOptions[$0][YelpFilters.FilterCode] as! String }).joinWithSeparator(",") ]
    }

}

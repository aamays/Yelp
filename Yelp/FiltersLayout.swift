//
//  FiltersLayout.swift
//  Yelp
//
//  Created by Amay Singhal on 9/24/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import Foundation


struct FiltersLayout {
    static let SectionName = "section_name"
    static let IsExpandable = "is_expandable"
    static let Options = "options"
    static let filters = [[FiltersLayout.SectionName: "",
                          FiltersLayout.IsExpandable: false,
                               FiltersLayout.Options: ["Offering a Deal"]],
                          [FiltersLayout.SectionName: "Distance",
                          FiltersLayout.IsExpandable: true,
                               FiltersLayout.Options: ["Auto"]]]
}
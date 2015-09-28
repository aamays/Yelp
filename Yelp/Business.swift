//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    let businessLocation: CLLocation?
    let open: Bool?
    let displayPhone: String?
    let displayAddress: String?

    init(dictionary: NSDictionary) {

        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary

        var address = ""
        var dispAddr = ""
        var tempBusinessLocation: CLLocation? = nil
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            // var street: String? = ""
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }

            // get restaurent location coordinates from response
            if let coordinateDict = location!["coordinate"] as? NSDictionary {
                let lat = coordinateDict["latitude"] as! CLLocationDegrees
                let long = coordinateDict["longitude"] as! CLLocationDegrees
                tempBusinessLocation = CLLocation(latitude: lat, longitude: long)
            }

            if let addr = location!["display_address"] as? [String] {
                dispAddr = addr.joinWithSeparator(", ")
            }
        }
        self.displayAddress = dispAddr
        self.businessLocation = tempBusinessLocation
        self.address = address

        if let isClosed = dictionary["is_closed"] as? Bool {
            open = !isClosed
        } else {
            open = false
        }

        if let phone = dictionary["display_phone"] as? String {
            displayPhone = phone
        } else {
            displayPhone = nil
        }

        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, filters: [YelpFilters]?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, filters: filters, completion: completion)
    }

    class func searchWithTerm(term: String, location: CLLocation, filters: [YelpFilters]?, offset: Int?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, atLocation: location, withFilters: filters, offset: offset, completion: completion)
    }
}

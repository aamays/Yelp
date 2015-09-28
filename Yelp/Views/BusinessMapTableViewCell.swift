//
//  BusinessMapTableViewCell.swift
//  Yelp
//
//  Created by Amay Singhal on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessMapTableViewCell: UITableViewCell {

    @IBOutlet weak var businessLocationMapView: MKMapView!

    var businessLocation: CLLocation! {
        didSet {
            updateMapView()
        }
    }

    let regionRadius: CLLocationDistance = 250

    func updateMapView() {
        centerMapOnLocation(businessLocation)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper Methods
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        businessLocationMapView.setRegion(coordinateRegion, animated: true)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        businessLocationMapView.addAnnotation(dropPin)
    }
}

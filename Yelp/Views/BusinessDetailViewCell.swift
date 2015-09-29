//
//  BusinessDetailViewCell.swift
//  Yelp
//
//  Created by Amay Singhal on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessDetailViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!

    var business: Business! {
        didSet {
            updateBusinessDetailsInCell()
        }
    }

    func updateBusinessDetailsInCell() {
        businessImageView.contentMode = .ScaleToFill
        businessImageView.setImageWithURL(business.imageURL)
        businessNameLabel.text = business.name
        ratingsImageView.setImageWithURL(business.ratingImageURL)
        categoryLabel.text = business.categories
        reviewLabel.text = "\(business.reviewCount!) Reviews"

        openLabel.text = business.open! ? "Open" : "Closed"
        openLabel.textColor = business.open! ? UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1) : UIColor.redColor()
        distanceLabel.text = business.distance
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

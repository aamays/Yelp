//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Amay Singhal on 9/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!

    var business: Business! {
        didSet {
            updateBusinessDetailsInCell()
        }
    }

    func updateBusinessDetailsInCell() {
        nameLabel.text = business.name
        thumbImageView.setImageWithURL(business.imageURL)
        categoriesLabel.text = business.categories
        reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
        ratingImageView.setImageWithURL(business.ratingImageURL)
        distanceLabel.text = business.distance
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true

        // adjusting label width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // adjusting label width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BusinessAddressTableViewCell.swift
//  Yelp
//
//  Created by Amay Singhal on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!

    var businessAddress: String! {
        didSet {
            addressLabel.text = businessAddress
        }
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

//
//  FilterTableViewCell.swift
//  Yelp
//
//  Created by Amay Singhal on 9/24/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterTableViewCellDelegate: class {
    optional func filterCellSwitchDidToggle(cell: FilterTableViewCell, newValue:Bool)
}

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!

    weak var delegate: FilterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchStateToggled(sender: UISwitch) {
        delegate?.filterCellSwitchDidToggle!(self, newValue: sender.on)
    }
}

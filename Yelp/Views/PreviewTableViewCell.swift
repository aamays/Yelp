//
//  PreviewTableViewCell.swift
//  Yelp
//
//  Created by Amay Singhal on 9/25/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class PreviewTableViewCell: UITableViewCell {

    struct CellState {
        static let Collapsed = ("c" , UIColor.lightGrayColor(), UIFont(name: "fontastic", size: 17))
        static let Checked = ("d" , UIColor.cyanColor(), UIFont(name: "fontastic", size: 20))
        static let Unchecked = ("e" , UIColor.lightGrayColor(), UIFont(name: "fontastic", size: 20))
    }

    @IBOutlet weak var cellStatusLabel: UILabel!
    @IBOutlet weak var previewFilterNameLabel: UILabel!


    var cellState = CellState.Collapsed {
        didSet {
            cellStatusLabel?.text = cellState.0
            cellStatusLabel?.textColor = cellState.1
            cellStatusLabel?.font = cellState.2
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

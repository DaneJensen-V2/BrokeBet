//
//  HeaderTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/13/21.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var middleRightLabel: UILabel!
    @IBOutlet weak var RightLeftLabe: UILabel!
    @IBOutlet weak var RightMostLabel: UILabel!
    @IBOutlet weak var middleLeftLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

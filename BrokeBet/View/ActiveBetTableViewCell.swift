//
//  ActiveBetTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 12/10/21.
//

import UIKit

class ActiveBetTableViewCell: UITableViewCell {

    @IBOutlet weak var paidOutLabel: UILabel!
    @IBOutlet weak var oddsLabelBottom: UILabel!
    @IBOutlet weak var wagerLabel: UILabel!
    @IBOutlet weak var betNameLabel: UILabel!
    @IBOutlet weak var oddsLabel: UILabel!
    @IBOutlet weak var homeShortName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayShortName: UILabel!
    @IBOutlet weak var awayImagep: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

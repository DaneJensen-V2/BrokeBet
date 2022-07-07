//
//  StatTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/13/21.
//

import UIKit

class StatTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var compLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var tdLabel: UILabel!
    @IBOutlet weak var ydsLabel: UILabel!
    @IBOutlet weak var attLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

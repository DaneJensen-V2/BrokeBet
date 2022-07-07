//
//  GameTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var awayTeamAbbrv: UILabel!
    @IBOutlet weak var thLabel: UILabel!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var awayteamScore: UILabel!
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var quarter: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var homeTeamScore: UILabel!
    @IBOutlet weak var homeRecord: UILabel!
    @IBOutlet weak var homeTeamAbbrv: UILabel!
    @IBOutlet weak var awayRecord: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //backgroundColor = .clear // very important
            layer.masksToBounds = false
            layer.shadowOpacity = 0.23
            layer.shadowRadius = 1
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = UIColor.black.cgColor
            
            

            // add corner radius on `contentView`
            contentView.backgroundColor = .white
        // Configure the view for the selected state
    }
    
}

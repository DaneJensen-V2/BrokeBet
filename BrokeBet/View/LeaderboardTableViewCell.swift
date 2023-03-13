//
//  LeaderboardTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/31/22.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var positionTop: NSLayoutConstraint!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear // very important
          layer.masksToBounds = false
          layer.shadowOpacity = 0.23
          layer.shadowRadius = 4
          layer.shadowOffset = CGSize(width: 0, height: 0)
          layer.shadowColor = UIColor.black.cgColor

          // add corner radius on `contentView`
          contentView.backgroundColor = .white
          contentView.layer.cornerRadius = 8
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ParlayTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 9/3/22.
//

import UIKit

var cellToDelete = 0
class ParlayTableViewCell: UITableViewCell {

    var index = 0
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var spread: UILabel!
    @IBOutlet weak var oddsLabel: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!
    @IBOutlet weak var matchupLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var buttonX: NSLayoutConstraint!
    @IBOutlet weak var xButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        xButton.layer.cornerRadius = xButton.layer.frame.height / 2
    }

    func showXButton(){
        UIView.animate(withDuration: 0.3) {
           // self.buttonX.constant = 10
            self.xButton.transform = CGAffineTransform(translationX: 45, y: 0)
            self.teamLabel.transform = CGAffineTransform(translationX: 35, y: 0)
            self.matchupLabel.transform = CGAffineTransform(translationX: 35, y: 0)
            self.spreadLabel.transform = CGAffineTransform(translationX: 35, y: 0)
            self.spread.transform = CGAffineTransform(translationX: 35, y: 0)

        }
       
    }
    func hideXButton(){
        UIView.animate(withDuration: 0.3) {
           // self.buttonX.constant = 10
            self.spread.transform = CGAffineTransform(translationX: 0, y: 0)
            self.xButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.teamLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.matchupLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.spreadLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
       
    }
    
    @IBAction func xClicked(_ sender: UIButton) {
        cellToDelete = index
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteParlay"), object: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

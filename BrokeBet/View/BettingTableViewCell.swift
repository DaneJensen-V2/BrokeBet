//
//  BettingTableViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/17/21.
//

import UIKit
import BottomHalfModal
var gameIDclicked = ""
var teamIDClicked = ""

class BettingTableViewCell: UITableViewCell {
    @IBOutlet weak var gameID: UILabel!
    @IBOutlet weak var spreadAway: UIButton!
    @IBOutlet weak var totalAway: UIButton!
    @IBOutlet weak var moneyHome: UIButton!
    
    @IBOutlet weak var spreadHome: UIButton!
    @IBOutlet weak var totalHome: UIButton!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var moneyAway: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var homeTeamImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        spreadAway.layer.borderWidth = 1.5
        spreadAway.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        
        totalAway.layer.borderWidth = 1.5
        totalAway.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        
        moneyAway.layer.borderWidth = 1.5
        moneyAway.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        
        spreadHome.layer.borderWidth = 1.5
        spreadHome.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        
        totalHome.layer.borderWidth = 1.5
        totalHome.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        
        moneyHome.layer.borderWidth = 1.5
        moneyHome.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        
        

        // Configure the view for the selected state
    }
    
    @IBAction func spreadAwayPushed(_ sender: UIButton) {
        teamIDClicked = "Away"
    //    print(spreadAway.currentTitle)
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        print("push")
        let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
    
        vc.titleText = title.text!
        vc.betType = "Spread"
        if let firstLine = spreadAway.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
        }
        if let secondLine = spreadAway.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
        }
        vc.teamNameText = awayTeamName.text!
      //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!
        
        self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
    }
    @IBAction func moneyAwayPushed(_ sender: UIButton) {
        teamIDClicked = "Away"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            print("push")
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!
            vc.betType = "Moneyline"
            vc.odds = moneyAway.currentTitle!

            vc.spread = moneyAway.currentTitle!
            vc.teamNameText = awayTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!

            self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
    }
    @IBAction func totalAwayPushed(_ sender: UIButton) {
        teamIDClicked = "Away"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            print("push")
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!
            vc.betType = "Over/Under"
            vc.spread = totalAway.currentTitle!
        if let firstLine = totalAway.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
        }
        if let secondLine = totalAway.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
        }
        gameIDclicked = gameID.text!

            vc.teamNameText = awayTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
            
            self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
    }
    @IBAction func spreadHomePushed(_ sender: UIButton) {
        teamIDClicked = "Home"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            print("push")
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!
        if let firstLine = spreadHome.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
        }
        if let secondLine = spreadHome.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
        }
            vc.betType = "Spread"
            vc.teamNameText = homeTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!

            self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
        
    }
    @IBAction func moneyHomePushed(_ sender: UIButton) {
        
        teamIDClicked = "Home"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            print("push")
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!

            vc.betType = "Moneyline"
            vc.spread = moneyHome.currentTitle!
       
            vc.odds = moneyHome.currentTitle!
            vc.teamNameText = homeTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!

            self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
    }
    @IBAction func totalHomePushed(_ sender: UIButton) {
        teamIDClicked = "Home"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            print("push")
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!

            vc.betType = "Over/Under"
        if let firstLine = totalHome.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
        }
        if let secondLine = totalHome.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
        }
            vc.teamNameText = homeTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!

            self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
    }
}

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
var buttonIndex = [0,0]
class BettingTableViewCell: UITableViewCell {
    var index = 0
    var selectedButtons = [false, false, false, false, false, false]
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
    var nameToAbbrv: [String: String] = ["Cardinals":"ARI", "Falcons": "ATL", "Ravens" : "BAL", "Bills" : "BUF", "Panthers" : "CAR", "Bears": "CHI", "Bengals" : "CIN", "Browns" : "CLE", "Cowboys" : "DAL", "Broncos" : "DEN", "Lions" : "DET", "Packers": "GB", "Texans" : "HOU", "Colts" : "IND", "Jacksonville" : "JAX", "Chiefs" : "KC", "Chargers" : "LAC", "Rams" : "LAR", "Raiders" : "LV", "Dolphins" : "MIA", "Vikings" : "MIN", "Patriots" : "NE", "Saints" : "NO", "Giants" : "NYG", "Jets" : "NYG", "Eagles" : "PHI", "Steelers" : "PIT", "Seahawks" : "SEA", "49ers" : "SF", "Buccaneers" : "TB", "Titans" : "TEN", "Washington" : "WSH"]


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
        //Common Vars
        buttonIndex = [index, 0]
        teamIDClicked = "Away"
        var spread = ""
        var odds = ""
        teamBetOn = awayTeamName.text ?? "Null"
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"
        
        
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
    
        vc.titleText = title.text!
        vc.betType = "Spread"
        if let firstLine = spreadAway.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
            spread = firstLine
        }
        if let secondLine = spreadAway.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
            odds = secondLine
        }
        vc.teamNameText = awayTeamName.text!
      //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!
        
        if creatingParlay {
            if spreadAway.backgroundColor == UIColor(named: "darkerGreen"){
                print("test")

                spreadAway.backgroundColor = UIColor(named: "lightGreen")
                print(activeGames[index].gameID)
                print(teamIDClicked)
                removeFromParlay(gameID: activeGames[index].gameID, typeOfBet: "Spread", teamID: teamIDClicked)
                tableData[index].selectedButtons[0] = false
            }
            else{
                spreadAway.backgroundColor = UIColor(named: "darkerGreen")
                addToParlay(typeOfBet: "Spread", spread: spread, odds: odds, teamPicked: teamIDClicked, game: activeGames[index])
                tableData[index].selectedButtons[0] = true

            }
                
           }
           else   {
               self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
           }
    }
    @IBAction func moneyAwayPushed(_ sender: UIButton) {
        //Common Vars
        buttonIndex = [index, 1]
        teamIDClicked = "Away"
        var spread = ""
        var odds = ""
        teamBetOn = awayTeamName.text ?? "Null"
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!
            vc.betType = "Moneyline"
            vc.odds = moneyAway.currentTitle!
            odds = moneyAway.currentTitle!
            vc.spread = moneyAway.currentTitle!
           spread = moneyAway.currentTitle!
            vc.teamNameText = awayTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!

        if creatingParlay {
            if moneyAway.backgroundColor == UIColor(named: "darkerGreen"){

                moneyAway.backgroundColor = UIColor(named: "lightGreen")
                print(activeGames[index].gameID)
                print(teamIDClicked)
                removeFromParlay(gameID: activeGames[index].gameID, typeOfBet: "Moneyline", teamID: teamIDClicked)
                tableData[index].selectedButtons[1] = false
            }
            else{
                moneyAway.backgroundColor = UIColor(named: "darkerGreen")
                addToParlay(typeOfBet: "Moneyline", spread: spread, odds: odds, teamPicked: teamIDClicked, game: activeGames[index])
                tableData[index].selectedButtons[1] = true

            }
                
           }
           else   {
               self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
           }
    }
    @IBAction func totalAwayPushed(_ sender: UIButton) {
        //Common Vars
        buttonIndex = [index, 2]
        teamIDClicked = "Away"
        var spread = ""
        var odds = ""
        teamBetOn = awayTeamName.text ?? "Null"
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"

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
            spread = firstLine
        }
        if let secondLine = totalAway.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
            odds = secondLine
        }
        gameIDclicked = gameID.text!

            vc.teamNameText = awayTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
            
        if creatingParlay {
            if totalAway.backgroundColor == UIColor(named: "darkerGreen"){

                totalAway.backgroundColor = UIColor(named: "lightGreen")
                removeFromParlay(gameID: activeGames[index].gameID, typeOfBet: "Over/Under", teamID: teamIDClicked)
                tableData[index].selectedButtons[3] = false
            }
            else{
                totalAway.backgroundColor = UIColor(named: "darkerGreen")
                addToParlay(typeOfBet: "Over/Under", spread: spread, odds: odds, teamPicked: teamIDClicked, game: activeGames[index])
                tableData[index].selectedButtons[3] = true

            }
                
           }
           else   {
               self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
           }
    }
    @IBAction func spreadHomePushed(_ sender: UIButton) {
        //Common Vars
        buttonIndex = [index, 3]
        teamIDClicked = "Home"
        var spread = ""
        var odds = ""
        teamBetOn = awayTeamName.text ?? "Null"
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"
        
        
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
    
        vc.titleText = title.text!
        vc.betType = "Spread"
        if let firstLine = spreadHome.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
            spread = firstLine
        }
        if let secondLine = spreadHome.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
            odds = secondLine
        }
        vc.teamNameText = homeTeamName.text!
      //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!
        
        if creatingParlay {
            if spreadHome.backgroundColor == UIColor(named: "darkerGreen"){
                print("test")

                spreadHome.backgroundColor = UIColor(named: "lightGreen")
    
                removeFromParlay(gameID: activeGames[index].gameID, typeOfBet: "Spread", teamID: teamIDClicked)
                tableData[index].selectedButtons[3] = false
            }
            else{
                spreadHome.backgroundColor = UIColor(named: "darkerGreen")
                addToParlay(typeOfBet: "Spread", spread: spread, odds: odds, teamPicked: teamIDClicked, game: activeGames[index])
                tableData[index].selectedButtons[3] = true

            }
                
           }
           else   {
               self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
           }
        
    }
    @IBAction func moneyHomePushed(_ sender: UIButton) {
        //Common Vars
        buttonIndex = [index, 4]
        teamIDClicked = "Home"
        var spread = ""
        var odds = ""
        teamBetOn = awayTeamName.text ?? "Null"
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!
            vc.betType = "Moneyline"
            vc.odds = moneyHome.currentTitle!
            odds = moneyHome.currentTitle!
            vc.spread = moneyHome.currentTitle!
           spread = moneyHome.currentTitle!
            vc.teamNameText = homeTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
        gameIDclicked = gameID.text!

        if creatingParlay {
            if moneyHome.backgroundColor == UIColor(named: "darkerGreen"){

                moneyHome.backgroundColor = UIColor(named: "lightGreen")
                print(activeGames[index].gameID)
                print(teamIDClicked)
                removeFromParlay(gameID: activeGames[index].gameID, typeOfBet: "Moneyline", teamID: teamIDClicked)
                tableData[index].selectedButtons[4] = false
            }
            else{
                moneyHome.backgroundColor = UIColor(named: "darkerGreen")
                addToParlay(typeOfBet: "Moneyline", spread: spread, odds: odds, teamPicked: teamIDClicked, game: activeGames[index])
                tableData[index].selectedButtons[4] = true

            }
                
           }
           else   {
               self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
           }
    }
    @IBAction func totalHomePushed(_ sender: UIButton) {
        //Common Vars
        buttonIndex = [index, 5]
        teamIDClicked = "Home"
        var spread = ""
        var odds = ""
        teamBetOn = awayTeamName.text ?? "Null"
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"

        //    print(spreadAway.currentTitle)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            print("push")
            let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
        
            vc.titleText = title.text!
            vc.betType = "Over/Under"
            vc.spread = totalHome.currentTitle!
        if let firstLine = totalHome.currentTitle!.components(separatedBy: CharacterSet.newlines).first {
            vc.spread = firstLine
            spread = firstLine
        }
        if let secondLine = totalHome.currentTitle!.components(separatedBy: CharacterSet.newlines).last {
            vc.odds = secondLine
            odds = secondLine
        }
        gameIDclicked = gameID.text!

            vc.teamNameText = awayTeamName.text!
          //  vc.teamName!.text = awayTeamName.text
            
        if creatingParlay {
            if totalHome.backgroundColor == UIColor(named: "darkerGreen"){

                totalHome.backgroundColor = UIColor(named: "lightGreen")
                removeFromParlay(gameID: activeGames[index].gameID, typeOfBet: "Over/Under", teamID: teamIDClicked)
                tableData[index].selectedButtons[5] = false
            }
            else{
                totalHome.backgroundColor = UIColor(named: "darkerGreen")
                addToParlay(typeOfBet: "Over/Under", spread: spread, odds: odds, teamPicked: teamIDClicked, game: activeGames[index])
                tableData[index].selectedButtons[5] = true

            }
                
           }
           else   {
               self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)
           }
    }
    func addToParlay(typeOfBet : String, spread: String, odds : String, teamPicked : String, game : MatchupData){
        var tempComponent : parlayComponent?
        if teamPicked == "Home"{
             tempComponent = parlayComponent(teamID: teamPicked, typeOfBet: typeOfBet, odds: odds, betGameID: game.gameID, spread: spread, outcome: "In Progress", homeAbbrv: game.homeTeam, awayAbbrv: game.awayTeam, teamBetOn: game.homeTeam)
        }
        else if teamPicked == "Away"{
             tempComponent = parlayComponent(teamID: teamPicked, typeOfBet: typeOfBet, odds: odds, betGameID: game.gameID, spread: spread, outcome: "In Progress", homeAbbrv: game.homeTeam, awayAbbrv: game.awayTeam, teamBetOn: game.awayTeam)
        }
        parlayComponents.append(tempComponent!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "parlay"), object: nil)

    }
    func removeFromParlay(gameID : String, typeOfBet : String, teamID : String){
        var count = 0
        for parlay in parlayComponents{
            if parlay.betGameID == gameID && typeOfBet == parlay.typeOfBet && teamID == parlay.teamID{
                parlayComponents.remove(at: count)
                print("test 2")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "parlay"), object: nil)
                return
            }
            count += 1
        }
    }
}

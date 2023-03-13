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
var buttonRef : UIButton?
var buttonIndex = [0,0,0]
var currentGame : MatchupData?
private var shadowLayer: CAShapeLayer!
var nameToAbbrv: [String: String] = ["Cardinals":"ARI", "Falcons": "ATL", "Ravens" : "BAL", "Bills" : "BUF", "Panthers" : "CAR", "Bears": "CHI", "Bengals" : "CIN", "Browns" : "CLE", "Cowboys" : "DAL", "Broncos" : "DEN", "Lions" : "DET", "Packers": "GB", "Texans" : "HOU", "Colts" : "IND", "Jaguars" : "JAX", "Chiefs" : "KC", "Chargers" : "LAC", "Rams" : "LAR", "Raiders" : "LV", "Dolphins" : "MIA", "Vikings" : "MIN", "Patriots" : "NE", "Saints" : "NO", "Giants" : "NYG", "Jets" : "NYG", "Eagles" : "PHI", "Steelers" : "PIT", "Seahawks" : "SEA", "49ers" : "SF", "Buccaneers" : "TB", "Titans" : "TEN", "Washington" : "WSH"]



class BettingTableViewCell: UITableViewCell {
    var index = 0
    var section = 0
    var selectedButtons = [false, false, false, false, false, false]
    @IBOutlet weak var gameID: UILabel!
    @IBOutlet weak var spreadAway: UIButton!
    @IBOutlet weak var totalAway: UIButton!
    @IBOutlet weak var moneyHome: UIButton!
    
    @IBOutlet weak var cellBG: UIView!
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
        print("Awake from nib")

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 3, bottom: 0, right: 30))

        shadowLayer = CAShapeLayer()
      
        shadowLayer.path = UIBezierPath(roundedRect: contentView.frame, cornerRadius: 10).cgPath
     shadowLayer.fillColor = UIColor.clear.cgColor

        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3

        layer.insertSublayer(shadowLayer, at: 0)
    }



    override func setSelected(_ selected: Bool, animated: Bool) { 
        super.setSelected(selected, animated: false)
        
   
        spreadAway.layer.cornerRadius = 5
        
        totalAway.layer.cornerRadius = 5
        
        moneyAway.layer.cornerRadius = 5
        
        spreadHome.layer.cornerRadius = 5
        
        totalHome.layer.cornerRadius = 5
        
        moneyHome.layer.cornerRadius = 5
        
        cellBG.layer.cornerRadius = 10

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Layout Subviews")
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

       
    }
    @IBAction func spreadAway(_ sender: UIButton) {
        let selectedGame = tableData[section][index]
        buttonIndex = [index, 0, section]
        teamIDClicked = "Away"
        let betType = "Spread"
        var odds = ""
        var spread = ""
        if let firstLine = selectedGame.spreadAway.components(separatedBy: CharacterSet.newlines).first {
            spread = firstLine
        }
        if let secondLine = selectedGame.spreadAway.components(separatedBy: CharacterSet.newlines).last {
            odds = secondLine
        }
        let teamName = selectedGame.awayTeamName
        buttonClicked(betType: betType, odds: odds, spread: spread, teamName: teamName, sender : sender)
    }
    
    @IBAction func moneylineAway(_ sender: UIButton) {
        let selectedGame = tableData[section][index]
        buttonIndex = [index, 1, section]
        teamIDClicked = "Away"
        let betType = "Moneyline"
        let odds = selectedGame.moneyAway
        let spread = selectedGame.moneyAway
        let teamName = selectedGame.awayTeamName
        buttonClicked(betType: betType, odds: odds, spread: spread, teamName: teamName, sender : sender)
    }
    
    @IBAction func totalAway(_ sender: UIButton) {
        let selectedGame = tableData[section][index]
        buttonIndex = [index, 2, section]
        teamIDClicked = "Away"
        let betType = "Over/Under"
        var odds = ""
        var spread = ""
        if let firstLine = selectedGame.totalAway.components(separatedBy: CharacterSet.newlines).first {
            spread = firstLine
        }
        if let secondLine = selectedGame.totalAway.components(separatedBy: CharacterSet.newlines).last {
            odds = secondLine
        }
        let teamName = selectedGame.awayTeamName
        buttonClicked(betType: betType, odds: odds, spread: spread, teamName: teamName, sender : sender)
    }
    @IBAction func spreadHome(_ sender: UIButton) {
        let selectedGame = tableData[section][index]
        buttonIndex = [index, 3, section]
        let betType = "Spread"
        teamIDClicked = "Home"
        var odds = ""
        var spread = ""
        if let firstLine = selectedGame.spreadHome.components(separatedBy: CharacterSet.newlines).first {
            spread = firstLine
        }
        if let secondLine = selectedGame.spreadHome.components(separatedBy: CharacterSet.newlines).last {
            odds = secondLine
        }
        let teamName = selectedGame.homeTeamName
        buttonClicked(betType: betType, odds: odds, spread: spread, teamName: teamName, sender : sender)
    }
    @IBAction func moneylineHome(_ sender: UIButton) {
        let selectedGame = tableData[section][index]
        buttonIndex = [index, 4, section]
        teamIDClicked = "Home"
        let betType = "Moneyline"
        let odds = selectedGame.moneyHome
        let spread = selectedGame.moneyHome
        let teamName = selectedGame.homeTeamName
        buttonClicked(betType: betType, odds: odds, spread: spread, teamName: teamName, sender : sender)
    }
    @IBAction func totalHome(_ sender: UIButton) {
        let selectedGame = tableData[section][index]
        buttonIndex = [index, 5, section]
        let betType = "Over/Under"
        teamIDClicked = "Home"
        var odds = ""
        var spread = ""
        if let firstLine = selectedGame.totalHome.components(separatedBy: CharacterSet.newlines).first {
            spread = firstLine
        }
        if let secondLine = selectedGame.totalHome.components(separatedBy: CharacterSet.newlines).last {
            odds = secondLine
        }
        let teamName = selectedGame.homeTeamName
        buttonClicked(betType: betType, odds: odds, spread: spread, teamName: teamName, sender : sender)
    }
    
    func buttonClicked(betType : String, odds : String, spread : String, teamName : String, sender: UIButton){
        print("Section: \(section)")
        print("Index: \(index)")

        if !creatingParlay{
        UIView.animate(withDuration: 0.3) {
            buttonRef = sender
            sender.backgroundColor = UIColor(named: "darkerGreen")
            }
        }
        currentGame = activeGames[section][index]
        
        awayTeamAbbrv = nameToAbbrv[awayTeamName.text!] ?? "No Team"
        homeTeamAbbrv = nameToAbbrv[homeTeamName.text!] ?? "No Team"
        
        let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
        
        if creatingParlay{
            parlay(typeOfBet: betType, odds: odds, spread: spread, sender: sender)
        }
        else{
            showVC(betType: betType, odds: odds, spread: spread, teamName: teamName)
        }
    }
    func showVC(betType : String, odds : String, spread : String, teamName : String){
        let selectedGame = tableData[section][index]
        let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BetClicked") as! BetClickedViewController
    
        
        
        vc.titleText = selectedGame.title
        vc.betType = betType
        vc.teamNameText = teamName
        vc.odds = odds
        vc.spread = spread
        self.window?.rootViewController?.presentBottomHalfModal(vc, animated: true, completion: nil)

    }
    
    func parlay(typeOfBet : String, odds : String, spread : String, sender : UIButton){
      
            
            if sender.backgroundColor == UIColor(named: "darkerGreen"){
                UIView.animate(withDuration: 0.3) {
                    sender.backgroundColor = UIColor(named: "lightGreen")
                }

                removeFromParlay(gameID: activeGames[section][index].gameID, typeOfBet: typeOfBet, teamID: teamIDClicked)
                //print("Selected Button : \(tableData[section][index].selectedButtons[buttonIndex[1]])")
                tableData[section][index].selectedButtons[buttonIndex[1]] = false
            }
            else{
                UIView.animate(withDuration: 0.3) {
                  sender.backgroundColor = UIColor(named: "darkerGreen")
                }
                if let game = currentGame{
                    addToParlay(typeOfBet: typeOfBet, spread: spread, odds: odds, teamPicked: teamIDClicked, game: game, buttonPosition: buttonIndex[1], longHomeName: game.homeTeamLong, longAwayName: game.awayTeamLong, date: game.datePrint)
                    tableData[section][index].selectedButtons[buttonIndex[1]] = true
                }
              

            }
    }
    
    func addToParlay(typeOfBet : String, spread: String, odds : String, teamPicked : String, game : MatchupData, buttonPosition : Int, longHomeName : String, longAwayName : String, date : String){
        var tempComponent : parlayComponent?
        if teamPicked == "Home"{
            tempComponent = parlayComponent(teamID: teamPicked, typeOfBet: typeOfBet, odds: odds, betGameID: game.gameID, spread: spread, outcome: "Open", homeAbbrv: game.homeTeam, longHomeName: longHomeName, longAwayName: longAwayName, date: date, awayAbbrv: game.awayTeam, teamBetOn: game.homeTeam, league: game.league, buttonIndex: buttonIndex)
        }
        else if teamPicked == "Away"{
            tempComponent = parlayComponent(teamID: teamPicked, typeOfBet: typeOfBet, odds: odds, betGameID: game.gameID, spread: spread, outcome: "Open", homeAbbrv: game.homeTeam, longHomeName: longHomeName, longAwayName: longAwayName, date: date, awayAbbrv: game.awayTeam, teamBetOn: game.awayTeam, league: game.league, buttonIndex: buttonIndex)
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
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}

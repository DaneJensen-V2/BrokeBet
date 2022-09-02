//
//  PlayerStatsViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/12/21.
//

import UIKit

class PlayerStatsViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var backButton: UINavigationItem!
    var rusherHeaderPrinted = false
    var receivingHeaderPrinted = false
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var teamSelector: UISegmentedControl!
    
    @IBOutlet weak var statsTable: UITableView!
    
    @IBOutlet weak var centerLabel: UILabel!

    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var awayTeamScore: UILabel!
    @IBOutlet weak var homeTeamScore: UILabel!
    var currentWeek = 5
    @IBOutlet weak var awayTeamAbbrv: UILabel!
    @IBOutlet weak var homeTeamAbbrv: UILabel!
    @IBOutlet weak var quarter: UILabel!
    @IBOutlet weak var clock: UILabel!
    var teamSelected = "away"
    
    var passingCounter = 0
    var rushingCounter = 0
    var receivingCounter = 0
    
    let currentGame = currentGameList[rowSelected]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        statsTable.delegate = self
        statsTable.dataSource = self

        self.title = currentGame.awayTeam + " @ " + currentGame.homeTeam
        
        
        let awayTeamName = currentGameList[rowSelected].awayTeam
        
        let homeTeamName = currentGameList[rowSelected].homeTeam
        
        teamSelector.setTitle(awayTeamName, forSegmentAt: 0)
        
        teamSelector.setTitle(homeTeamName, forSegmentAt: 1)

        

        homeTeamImage.image = currentGame.homeLogo
        homeTeamAbbrv.text = currentGame.homeTeam
        homeTeamScore.text = currentGame.homeScore
        
        awayTeamImage.image = currentGame.awayLogo
        awayTeamAbbrv.text = currentGame.awayTeam
        awayTeamScore.text = currentGame.awayScore
        
        centerLabel.isHidden = true
        quarter.text = String(currentGame.Quarter) + "th"
        clock.text = currentGame.currentTime
        
        if(currentGame.currentTime == "0:00" && (currentGame.Quarter == 4 || currentGame.Quarter == 5)){
            quarter.isHidden = true
            clock.isHidden = true
            centerLabel.isHidden = false
        }
        var awayColor = hexStringToUIColor(hex: currentGameList[rowSelected].awayColor)
        
        statsTable.register(UINib(nibName : "HeaderTableViewCell", bundle: nil) , forCellReuseIdentifier: "headerCell")
        
        statsTable.register(UINib(nibName : "StatTableViewCell", bundle: nil) , forCellReuseIdentifier: "statCell")
        
        
  
    }
    
    
    @IBAction func teamSelected(_ sender: UISegmentedControl) {
        
        let awayColor = hexStringToUIColor(hex: currentGameList[rowSelected].awayColor)

        let homeColor = hexStringToUIColor(hex: currentGameList[rowSelected].homeColor)
        
        switch sender.selectedSegmentIndex
           {
           case 0:
            teamSelected = "away"
            DispatchQueue.main.async(execute: { () -> Void in
                            self.statsTable.reloadData()

                        })

           case 1:
            teamSelected = "home"
            DispatchQueue.main.async(execute: { () -> Void in
                            self.statsTable.reloadData()

                        })
        
            
            default:
               break
           }
        
    }
    func reloadCells(){
        
        statsTable.beginUpdates()
        statsTable.reloadData()
        statsTable.endUpdates()

            sleep(1)
        statsTable.isHidden = false
            
            

        
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func convertName(input : String) -> String{
        let tempInput = input
        let index = input.index(input.startIndex, offsetBy: 0)
        let fLetter = String(input[index])
        
        let space = input.firstIndex(of: " ")!
        let position: Int = input.distance(from: space, to: input.endIndex)

        let lastString = tempInput.suffix(position)
        
        let finalString = fLetter + ". " + lastString
        
        return finalString
    }


}
extension PlayerStatsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Passer Count")
        if (teamSelected == "away"){

        let totalRows =  currentGameList[rowSelected].awayReceivers.count + currentGameList[rowSelected].awayPassers.count + currentGameList[rowSelected].awayRushers.count + 3
        
        return totalRows
        }
        else if(teamSelected == "home"){
        let totalRows =  currentGameList[rowSelected].homeReceivers.count + currentGameList[rowSelected].homePassers.count + currentGameList[rowSelected].homeRushers.count + 3
        return totalRows
    }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        

        var passers = currentGameList[rowSelected].awayPassers
        var rushers = currentGameList[rowSelected].awayRushers
        var receivers = currentGameList[rowSelected].awayReceivers
        if (teamSelected == "away"){
             passers = currentGameList[rowSelected].awayPassers
             rushers = currentGameList[rowSelected].awayRushers
             receivers = currentGameList[rowSelected].awayReceivers
        }
        else{
             passers = currentGameList[rowSelected].homePassers
             rushers = currentGameList[rowSelected].homeRushers
             receivers = currentGameList[rowSelected].homeReceivers
            
        }
        
        if(indexPath.row == 0){
            print("RAN 1")
        let cell = statsTable.dequeueReusableCell(withIdentifier: "headerCell", for : indexPath) as! HeaderTableViewCell
            
            cell.leftLabel.text = "C/Att"
            cell.statLabel.text = "Passing"
            cell.RightLeftLabe.text = "INT"
            cell.middleLeftLabel.text = "Yds"
            cell.middleRightLabel.text = "TD"
            cell.RightMostLabel.text = "Sacks"
            rusherHeaderPrinted = true
        
        if(teamSelected == "away"){
        cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].awayColor).withAlphaComponent(0.25)
            //print("RAn")
            return cell
        }
        else if(teamSelected == "home"){
            cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].homeColor).withAlphaComponent(0.25)
                //print("RAn")
                return cell
        }
        }
        else if(passers.count == 0){
            
        }
        else if (indexPath.row < passers.count + 1){
          //  print("Row Selected")
          //  print(rowSelected)
          //  print(currentGameList[rowSelected].awayPassers.count)

           let  cell = statsTable.dequeueReusableCell(withIdentifier: "statCell", for : indexPath) as! StatTableViewCell
            
            let tempPassers = passers
            
            cell.nameLabel.text = convertName(input: tempPassers[indexPath.row - 1].passerName)
            cell.compLabel.text = tempPassers[indexPath.row - 1].passAT
            cell.compLabel.textAlignment = .left
            cell.attLabel.text = tempPassers[indexPath.row - 1].yards
            
            cell.ydsLabel.text = tempPassers[indexPath.row - 1].TD
            
            cell.tdLabel.text = tempPassers[indexPath.row - 1].INT
            cell.intLabel.text = tempPassers[indexPath.row - 1].sacks
            return cell
            
        }
        else if(indexPath.row == passers.count + 1){
            let cell = statsTable.dequeueReusableCell(withIdentifier: "headerCell", for : indexPath) as! HeaderTableViewCell
            
            cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].awayColor).withAlphaComponent(0.25)
            cell.leftLabel.text = "Car"
            cell.statLabel.text = "Rushing"
            cell.RightLeftLabe.text = "TD"
            cell.middleLeftLabel.text = "Yds"
            cell.middleRightLabel.text = "Avg"
            cell.RightMostLabel.text = "Long"
            rusherHeaderPrinted = true
                print("RAn")
            if(teamSelected == "away"){
            cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].awayColor).withAlphaComponent(0.25)
                //print("RAn")
                return cell
            }
            else if(teamSelected == "home"){
                cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].homeColor).withAlphaComponent(0.25)
                    //print("RAn")
                    return cell
            }
        }
        else if(indexPath.row < passers.count + rushers.count + 2){
       
            
            let cell = statsTable.dequeueReusableCell(withIdentifier: "statCell", for : indexPath) as! StatTableViewCell
             
             let tempRushers = rushers
            let index = passers.count + 2
             
            cell.nameLabel.text = convertName(input: tempRushers[indexPath.row - index].rusherName)
             cell.compLabel.text = tempRushers[indexPath.row - index].rushAT
            cell.attLabel.text = tempRushers[indexPath.row - index].yards
             
             cell.ydsLabel.text = tempRushers[indexPath.row - index].AVG
            cell.compLabel.textAlignment = .center

             
             cell.tdLabel.text = tempRushers[indexPath.row - index].TD
             cell.intLabel.text = tempRushers[indexPath.row - index].Long
             return cell
        }
        else if(indexPath.row == passers.count + rushers.count + 2){
            let cell = statsTable.dequeueReusableCell(withIdentifier: "headerCell", for : indexPath) as! HeaderTableViewCell

            cell.leftLabel.text = "Rec"
            cell.statLabel.text = "Receiving"
            cell.RightLeftLabe.text = "TD"
            cell.middleLeftLabel.text = "Yds"
            cell.middleRightLabel.text = "Avg"
            cell.RightMostLabel.text = "Long"
            receivingHeaderPrinted = true
                print("RAn")
            if(teamSelected == "away"){
            cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].awayColor).withAlphaComponent(0.25)
                //print("RAn")
                return cell
            }
            else if(teamSelected == "home"){
                cell.colorView.backgroundColor = hexStringToUIColor(hex: currentGameList[rowSelected].homeColor).withAlphaComponent(0.25)
                    //print("RAn")
                    return cell
            }
                return cell
        }
        else if(indexPath.row < passers.count + rushers.count + 3 + receivers.count){
       
            let index = passers.count + rushers.count + 3

            let cell = statsTable.dequeueReusableCell(withIdentifier: "statCell", for : indexPath) as! StatTableViewCell
             
            let tempReceiver = receivers
             
             cell.nameLabel.text = convertName(input: tempReceiver[indexPath.row - index].receiverName)
            cell.compLabel.textAlignment = .center
             cell.compLabel.text = tempReceiver[indexPath.row - index].receptions
            cell.attLabel.text = tempReceiver[indexPath.row - index].yards
             
             cell.ydsLabel.text = tempReceiver[indexPath.row - index].AVG
             
             cell.tdLabel.text = tempReceiver[indexPath.row - index].TD
             cell.intLabel.text = tempReceiver[indexPath.row - index].Long
            receivingCounter += 1
            return cell
        }

        let cell = statsTable.dequeueReusableCell(withIdentifier: "headerCell", for : indexPath) as! HeaderTableViewCell
        
        cell.colorView.backgroundColor = UIColor.white
        cell.leftLabel.text = ""
        cell.statLabel.text = ""
        cell.RightLeftLabe.text = ""
        cell.middleLeftLabel.text = ""
        cell.middleRightLabel.text = ""
        cell.RightMostLabel.text = ""
            //print("RAn")
            return cell
         
    }
    
    
    
}

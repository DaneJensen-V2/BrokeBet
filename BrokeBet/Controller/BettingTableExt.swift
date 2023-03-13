//
//  BettingTableExt.swift
//  BrokeBet
//
//  Created by Dane Jensen on 9/12/22.
//

import Foundation
import UIKit
extension BettingViewController{
    func convertToTableStruct(completion: @escaping (Bool)->Void){
        print("Converting")
        do{
            var section = 0
        for gameList in activeGames{
            for game in gameList{
                var tempTableData = betDataForTable(title: "", date: "", homeTeamImage: UIImage(named: "AppIcon")!, homeTeamColor: "", awayTeamImage:  UIImage(named: "AppIcon")!, awayTeamColor: "", awayTeamName: "", homeTeamName: "", spreadAway: "", moneyAway: "", totalAway: "", spreadHome: "", moneyHome: "", totalHome: "", league: "")
           
                if section == 0{
                    tempTableData.awayTeamImage = game.awayLogo ?? UIImage(named: "football")!
                    tempTableData.homeTeamImage = game.homeLogo ?? UIImage(named: "football")!
                }
                else if section == 1{
                    tempTableData.awayTeamImage =  game.awayLogo ?? UIImage(named: "basketball")!
                    tempTableData.homeTeamImage =  game.homeLogo ?? UIImage(named: "basketball")!
                }
                else if section == 2{
                    tempTableData.awayTeamImage =  UIImage(named: "football")!
                    tempTableData.homeTeamImage =  UIImage(named: "football")!
                }
                else if section == 3{
                    tempTableData.awayTeamImage =  game.awayLogo ?? UIImage(named: "baseball")!
                    tempTableData.homeTeamImage =  game.homeLogo ?? UIImage(named: "baseball")!
                }
         
            tempTableData.awayTeamColor = game.awayColor
            tempTableData.homeTeamColor = game.homeColor

            tempTableData.awayTeamName = game.awayTeamLong
            tempTableData.homeTeamName = game.homeTeamLong
            tempTableData.title = game.awayTeam + " " + game.awayTeamLong + " at " + game.homeTeam + " " + game.homeTeamLong
            tempTableData.date = game.datePrint.uppercased()
            var oddsHomeSymbol = ""
            var oddsAwaySymbol = ""
            
            if game.bettingData.spreadOddsHome > 0{
                oddsHomeSymbol = "+"
            }
            if game.bettingData.spreadOddsAway > 0 {
                oddsAwaySymbol = "+"
            }
            var symbol2 = ""
            if(game.bettingData.awaySpread > 0){
                symbol2 = "+"
                tempTableData.spreadAway = (symbol2 + String(game.bettingData.awaySpread) + "\n" + oddsAwaySymbol + String(Int(game.bettingData.spreadOddsAway)))
            }
            else if (game.bettingData.awaySpread == 0){
                tempTableData.spreadAway = ( "PICK" + "\n" + String(Int(game.bettingData.spreadOddsAway)))
            }
            else {
                symbol2 = ""
                tempTableData.spreadAway = (symbol2 + String(game.bettingData.awaySpread) + "\n" + oddsAwaySymbol + String(Int(game.bettingData.spreadOddsAway)))
            }
            
            if(game.bettingData.homeSpread > 0){
                symbol2 = "+"
                tempTableData.spreadHome = (symbol2 + String(game.bettingData.homeSpread) + "\n" + oddsHomeSymbol + String(Int(game.bettingData.spreadOddsHome)))
            }
            else if (game.bettingData.homeSpread == 0){
                tempTableData.spreadHome = ( "PICK" + "\n" + String(Int(game.bettingData.spreadOddsHome)))
            }
            else {
                symbol2 = ""
                tempTableData.spreadHome = (symbol2 + String(game.bettingData.homeSpread) + "\n" + oddsHomeSymbol + String(Int(game.bettingData.spreadOddsHome)))
            }
            var symbol = ""
            if(game.bettingData.moneyLineHome > 0){
                symbol = "+"
            }
            else {
                symbol = ""
            }
           
            
            tempTableData.moneyHome = (symbol + String(game.bettingData.moneyLineHome))

            tempTableData.totalHome = ("U " + String(game.bettingData.overUnder) + "\n" + String("-110"))


            if(game.bettingData.moneyLineAway > 0){
                symbol = "+"
            }
            
            else {
                symbol = ""
            }
            
            tempTableData.moneyAway = (symbol + String(game.bettingData.moneyLineAway))

            if game.bettingData.moneyLineAway == 0{
                tempTableData.moneyAway = "N/A"
            }
            tempTableData.totalAway = ("O " + String(game.bettingData.overUnder) + "\n" + String("-110"))
            
            if game.bettingData.moneyLineHome == 0{
                tempTableData.moneyHome = "N/A"
            }
            
           tableData[section].append(tempTableData)

        }
         section += 1
        }
        completion(true)

        }
    }
    
}
extension BettingViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count

   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
     return 185
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return tableData[section].count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "bettingTableHeader") as! bettingTableHeader
        headerView.leagueLabel.text = bettingTableSections[section]
        headerView.leagueImage.image = UIImage(named: bettingTableSections[section] + "-Logo")
    return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = bettingTable.dequeueReusableCell(withIdentifier: "bettingCell", for : indexPath) as! BettingTableViewCell
        let data = tableData[indexPath.section][indexPath.row]
        cell.index = indexPath.row
        cell.section = indexPath.section
        cell.awayTeamImage.image = data.awayTeamImage
        if indexPath.section == 2 {
             cell.awayTeamImage.backgroundColor = UIColor(hexString: "#" +  data.awayTeamColor)
             cell.homeTeamImage.backgroundColor = UIColor(hexString: "#" +  data.homeTeamColor)
        }
        else{
            cell.awayTeamImage.backgroundColor = .clear
            cell.homeTeamImage.backgroundColor = .clear
        }
       
        cell.homeTeamImage.setRounded()
        cell.awayTeamImage.setRounded()

        
        cell.homeTeamImage.image = data.homeTeamImage

        cell.awayTeamName.text = data.awayTeamName
        cell.homeTeamName.text = data.homeTeamName
        
        cell.title.text = data.title

        cell.date.text = data.date
        
        cell.spreadAway.setTitle(data.spreadAway, for: .normal)
        cell.spreadAway.titleLabel?.textAlignment = .center
        
        cell.spreadHome.setTitle(data.spreadHome, for: .normal)
        cell.spreadHome.titleLabel?.textAlignment = .center
        cell.backgroundColor = .clear
     
     
        cell.moneyAway.setTitle(data.moneyAway, for: .normal)
        
        cell.moneyHome.setTitle(data.moneyHome, for: .normal)

        cell.totalAway.setTitle(data.totalAway, for: .normal)
        cell.totalAway.titleLabel?.textAlignment = .center
        
        cell.totalHome.setTitle(data.totalHome, for: .normal)
        cell.totalHome.titleLabel?.textAlignment = .center

        
        let buttons = data.selectedButtons
        print(buttons)
        
        if buttons[0]{
            cell.spreadAway.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.spreadAway.backgroundColor = .white

        }
        if buttons[1]{
            cell.moneyAway.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.moneyAway.backgroundColor = .white

        }
        if buttons[2]{
            cell.totalAway.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.totalAway.backgroundColor = .white

        }
        if buttons[3]{
            cell.spreadHome.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.spreadHome.backgroundColor = .white

        }
        if buttons[4]{
            cell.moneyHome.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.moneyHome.backgroundColor = .white

        }
        if buttons[5]{
            cell.totalHome.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.totalHome.backgroundColor = .white

        }
    
        return cell
    }
}
        extension UIColor {
            convenience init(hexString: String) {
                let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                var int = UInt64()
                Scanner(string: hex).scanHexInt64(&int)
                let a, r, g, b: UInt64
                switch hex.count {
                case 3: // RGB (12-bit)
                    (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
                case 6: // RGB (24-bit)
                    (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
                case 8: // ARGB (32-bit)
                    (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
                default:
                    (a, r, g, b) = (255, 0, 0, 0)
                }
                self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
            }
        }
extension UIImageView {

   func setRounded() {
       let radius = self.frame.height  / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}


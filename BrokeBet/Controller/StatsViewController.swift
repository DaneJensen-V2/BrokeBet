//
//  StatsViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 12/10/21.
//

import UIKit
import Charts
struct Section{
    let title: String
    let options: [String]
    var isOpened = false
    
    init(title: String, options: [String], isOpened : Bool = false){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

class StatsViewController: UIViewController, UITableViewDelegate, ChartViewDelegate {
    
    @IBOutlet weak var topBG: UIView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var betsLabel: UILabel!
    @IBOutlet weak var avgBetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var betsLostLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var betsTable: UITableView!
    var allBets : [[UserBet]] = [[], []]
    let headerTitles = ["Active Bets", "Closed Bets"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIColor(named: "LogoColor")
        navigationController?.navigationBar.isTranslucent = false
        //sections = []
        allBets[0] = currentUser.activeBets.reversed()
        allBets[1] = currentUser.closedBets.reversed()
        betsTable.delegate = self
        self.betsTable.dataSource = self
        self.betsTable.register(UINib(nibName : "ActiveBetTableViewCell", bundle: nil) , forCellReuseIdentifier: "ActiveBetCell")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateStats), name: NSNotification.Name(rawValue: "updateStats"), object: nil)
        pieChart.delegate = self
        updateUI()
        setCharts()
        topBG.layer.cornerRadius = 15
        topBG.addShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.5, shadowRadius: 5)
    }
    @objc func updateStats(notification: NSNotification){
        allBets[0] = currentUser.activeBets.reversed()
        allBets[1] = currentUser.closedBets.reversed()
        updateUI()
    }
    func setCharts(){
      
        pieChart.drawHoleEnabled = true
        pieChart.drawSlicesUnderHoleEnabled = true
        pieChart.chartDescription.enabled = false
        pieChart.legend.enabled = false
       pieChart.chartDescription.enabled = false
      pieChart.highlightPerTapEnabled = false
        pieChart.transparentCircleRadiusPercent = 0.58
        //pieChart.holeRadiusPercent = 0.3
        let highlight1 = Highlight(x: 0, dataSetIndex: 0, stackIndex: 0)
        let highlight2 = Highlight(x: 1, dataSetIndex: 0, stackIndex: 1)
        pieChart.highlightValues([highlight1, highlight2])
        let entries = PieChartDataSet()
      
        entries.setColors(UIColor(named: "MatteGreen")!, UIColor(named: "RedColor")!)
        entries.append(PieChartDataEntry(value: Double(currentUser.Won), label: "Won"))
        entries.append(PieChartDataEntry(value: Double(currentUser.Lost), label: "Lost"))
        let data = PieChartData(dataSet: entries)
        
        pieChart.data = data

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
              pFormatter.maximumFractionDigits = 0
              pFormatter.multiplier = 1
            
              data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            data.setValueFont(.systemFont(ofSize: 14, weight: .bold))
              data.setValueTextColor(.white)
              

    }
    func updateUI(){
        print("Updating UI")
        DispatchQueue.main.async { [self] in
            let betAvg = currentUser.Earned / Double(currentUser.Bets)

            if !signedIn{
                nameLabel.text = "Sign in to view stats"
                avgBetLabel.text = "Avg/Bet: $ --"
                betsTable.isHidden = true
                
            }
            else{
                betsTable.isHidden = false
                nameLabel.text = currentUser.firstName + " " + currentUser.lastName
                
                if betAvg < 0{
                    let positiveAvg = betAvg * -1
                    avgBetLabel.text = "Avg/Bet: -$" +  String(format: "%.2f", positiveAvg)
                }
                else{
                    avgBetLabel.text = "Avg/Bet: $" +  String(format: "%.2f", betAvg)
                    
                }
                pieChart.isHidden = false
                
                if currentUser.Bets < 1{
                    avgBetLabel.text = "Avg/Bet: $ --"
                    pieChart.isHidden = true
                    
                }
            }
                wonLabel.text = String(currentUser.Won)
                betsLostLabel.text = String(currentUser.Lost)
                
                betsLabel.text = String(currentUser.Bets)
                
                
                if currentUser.Earned < 0{
                    let positiveEarned = currentUser.Earned * -1
                    earnedLabel.text = "-$" +   String(Int(positiveEarned))
                    earnedLabel.textColor = UIColor(named: "RedColor")
                }
                else{
                    earnedLabel.text = "$" +   String(Int(currentUser.Earned))
                    earnedLabel.textColor = UIColor(named: "MoneyGreen")
                    
                }
                betsTable.reloadData()
            }
           
        }
    }

   


extension StatsViewController : UITableViewDataSource{
  
     func numberOfSections(in tableView: UITableView) -> Int {
        return allBets.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return allBets[0].count
        }
        else if section == 1{
            return allBets[1].count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160 //or whatever you need
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }

        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        var currentBet : UserBet?
        currentBet = allBets[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveBetCell", for : indexPath) as! ActiveBetTableViewCell
        
        if let currentBet = currentBet{
            var outcomeColor = UIColor(named: "GreenColor")
            
            let wagerString = "$" + String(currentBet.amountBet)
            let wagerMutableString = NSMutableAttributedString()
            let wager = NSAttributedString(string: "Wager: ", attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans", size: 17)])
            let wagerAmount = NSAttributedString(string: wagerString, attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans-Bold", size: 17)])
            wagerMutableString.append(wager)
            wagerMutableString.append(wagerAmount)
            cell.wagerLabel.attributedText = wagerMutableString
            
            
            let oddsMutableString = NSMutableAttributedString()
            let oddsString =  String(currentBet.odds)
            let odds = NSAttributedString(string: "Odds: ", attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans", size: 17)])
            let oddsAmount = NSAttributedString(string: oddsString, attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans-Bold", size: 17)])
            oddsMutableString.append(odds)
            oddsMutableString.append(oddsAmount)
            cell.oddsLabelBottom.attributedText = oddsMutableString
            cell.oddsLabel.text = currentBet.odds
            cell.betNameLabel.text = currentBet.teamBetOn + " " + currentBet.odds
            cell.awayImagep.image = UIImage(named: currentBet.league + "-" + currentBet.awayAbbrv)
            cell.homeImage.image = UIImage(named: currentBet.league + "-" + currentBet.homeAbbrv)
            cell.homeShortName.text = currentBet.homeAbbrv
            cell.awayShortName.text = currentBet.awayAbbrv
            
            var paidOutString = ""
            if currentBet.outcome == "Won"{
                 paidOutString =  "$" + String(currentBet.potentialPayout)
                 outcomeColor = UIColor(named: "GreenColor")

            }
            else if currentBet.outcome == "Open" || currentBet.outcome == "In Progress"{
                outcomeColor = UIColor(named: "OrangeColor")
                paidOutString =  "--"

            }
            else{
                paidOutString =  "$0"
                outcomeColor = UIColor(named: "RedColor")

            }
            let paidOutFinalString = NSMutableAttributedString()
            let paidOut = NSAttributedString(string: "Paid Out: ", attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans", size: 17)])
            let paid = NSAttributedString(string: paidOutString, attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans-Bold", size: 17)])
            paidOutFinalString.append(paidOut)
            paidOutFinalString.append(paid)
            cell.paidOutLabel.attributedText = paidOutFinalString
            
            
            cell.outcomeLabel.text = currentBet.outcome
            cell.outcomeLabel.textColor = outcomeColor
        }
        
        
        
        return cell
        }
    
}

    

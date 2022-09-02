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
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var betsLabel: UILabel!
    @IBOutlet weak var avgBetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var betsLostLabel: UILabel!
    var pieChart = PieChartView()

    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var betsTable: UITableView!
    var allBets : [[UserBet]] = [[], []]
    let headerTitles = ["Active Bets", "Closed Bets"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIColor(named: "LogoColor")
        navigationController?.navigationBar.isTranslucent = false
        //sections = []
        allBets[0] = currentUser.activeBets
        allBets[1] = currentUser.closedBets
        betsTable.delegate = self
        self.betsTable.dataSource = self
        self.betsTable.register(UINib(nibName : "ActiveBetTableViewCell", bundle: nil) , forCellReuseIdentifier: "ActiveBetCell")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateStats), name: NSNotification.Name(rawValue: "updateStats"), object: nil)
        pieChart.delegate = self
        updateUI()
        setCharts()
    }
    @objc func updateStats(notification: NSNotification){
        allBets[0] = currentUser.activeBets
        allBets[1] = currentUser.closedBets
        updateUI()
    }
    func setCharts(){
        pieChart.frame = CGRect(x: 0, y: 0, width: chartView.frame.size.width, height: chartView.frame.size.height)
        pieChart.center = chartView.center
        view.addSubview(pieChart)
        pieChart.drawHoleEnabled = true
        pieChart.drawSlicesUnderHoleEnabled = true
        pieChart.chartDescription.enabled = false
        pieChart.legend.enabled = false
        pieChart.chartDescription.enabled = false
        pieChart.highlightPerTapEnabled = false
        pieChart.usePercentValuesEnabled = true
        let highlight1 = Highlight(x: 0, dataSetIndex: 0, stackIndex: 0)
        let highlight2 = Highlight(x: 1, dataSetIndex: 0, stackIndex: 1)
        pieChart.highlightValues([highlight1, highlight2])
        var entries = PieChartDataSet()
      
        entries.setColors(UIColor(named: "MatteGreen")!, UIColor(named: "RedColor")!)
        entries.append(PieChartDataEntry(value: Double(1), label: "Won"))
        entries.append(PieChartDataEntry(value: Double(currentUser.Lost), label: "Lost"))
        let data = PieChartData(dataSet: entries)

        let pFormatter = NumberFormatter()
              pFormatter.numberStyle = .percent
              pFormatter.maximumFractionDigits = 1
              pFormatter.multiplier = 1
              pFormatter.percentSymbol = " %"
              data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
              
            data.setValueFont(.systemFont(ofSize: 11, weight: .bold))
              data.setValueTextColor(.black)
              

        
        pieChart.data = data

        
    }
    func updateUI(){
        print("Updating UI")
        DispatchQueue.main.async { [self] in
            nameLabel.text = currentUser.firstName + " " + currentUser.lastName
            wonLabel.text = String(currentUser.Won)
            betsLostLabel.text = String(currentUser.Lost)
            
            betsLabel.text = String(currentUser.Bets)
            let betAvg = currentUser.Earned / Double(currentUser.Bets)
            
            if currentUser.Earned < 0{
                let positiveEarned = currentUser.Earned * -1
                earnedLabel.text = "-$" +   String(Int(positiveEarned))
                earnedLabel.textColor = .red
            }
            else{
                earnedLabel.text = "$" +   String(Int(currentUser.Earned))
                earnedLabel.textColor = .green

            }
            if betAvg < 0{
                let positiveAvg = betAvg * -1
                avgBetLabel.text = "AVG/BET: -$" +  String(format: "%.2f", betAvg)
            }
            else{
                avgBetLabel.text = "AVG/BET: $" +  String(format: "%.2f", betAvg)

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
      
        print("Index : " + String(indexPath.row))
        print("Active : " + String(currentUser.activeBets.count - 1))
        print("All : " + String(currentUser.activeBets.count - 1))

        var currentBet : UserBet?
        currentBet = allBets[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveBetCell", for : indexPath) as! ActiveBetTableViewCell
        
        if let currentBet = currentBet{
            
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
            cell.awayImagep.image = UIImage(named: currentBet.awayAbbrv)
            cell.homeImage.image = UIImage(named: currentBet.homeAbbrv)
            cell.homeShortName.text = currentBet.homeAbbrv
            cell.awayShortName.text = currentBet.awayAbbrv
            
            var paidOutString = ""
            if currentBet.outcome == "Won"{
                 paidOutString =  "$" + String(currentBet.potentialPayout)

            }
            else{
                paidOutString =  "$0"

            }
            let paidOutFinalString = NSMutableAttributedString()
            let paidOut = NSAttributedString(string: "Paid Out: ", attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans", size: 17)])
            let paid = NSAttributedString(string: paidOutString, attributes: [NSAttributedString.Key.font:UIFont(name: "FrancophilSans-Bold", size: 17)])
            paidOutFinalString.append(paidOut)
            paidOutFinalString.append(paid)
            cell.paidOutLabel.attributedText = paidOutFinalString
        }
        
        
        
        return cell
        }
    
}

    

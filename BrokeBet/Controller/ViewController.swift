//
//  ViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import UIKit
 
var rowSelected = 0
var gameNum = 0
var statsDone = true


class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var weekLabel: UILabel!
    
    var timer = Timer()
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var footballGame = footballMatch()
    
    let tempURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event="
    var gameID = ""
    var fullURLAway = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        loadData()
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        if let selection = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selection , animated: true)
        }
        else {
            print("NO SELECTION")
        }
    }
    @IBAction func reloadPressed(_ sender: Any) {
       runNumber = 0
        loadData()
    }
    func loadData(){
        currentGameList = []
        
        footballGame.performRequest(urlString: footballGame.gameURL)
        tableView.backgroundView = spinner
        spinner.startAnimating()
        tableView.separatorColor = .clear 
        var hasRun = false
        
        if(hasRun == false){
        
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                
               

        if (currentGameList.count == totalEvents){
            print("TEST")
            print(totalEvents)
            self.spinner.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.dataSource = self
            self.tableView.separatorColor = .gray
            self.tableView.register(UINib(nibName : "GameTableViewCell", bundle: nil) , forCellReuseIdentifier: "gameCell")

            DispatchQueue.main.async(execute: { () -> Void in
                            self.tableView.reloadData()

                        })
            hasRun = true

        }
                if(hasRun == true){
                    
                    self.timer.invalidate()
                    loadStats()
                    
                }
        })
        }

    }

}

func determineQuarter(Quarter: Int) -> String{
    if (Quarter == 1){
        return "st"
    }
    else if (Quarter == 2){
        return "nd"
    }
    else if(Quarter == 3){
        return "rd"
    }
    else if (Quarter == 4){
        return "th"
    }
    else {
        return "th"
    }
    
}

func loadStats()
{
    print("LOAD STATS RUN")
let Stats = teamStats()
let tempURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event="
    for game in currentGameList {

        usleep(100000)
        let gameID = game.gameID
        let gameURL = tempURL + gameID
        

        Stats.performRequest(urlString: gameURL)
        statsDone = false
        
    }
    usleep(700000)
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalEvents
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         rowSelected = indexPath.row
        self.performSegue(withIdentifier: "gameCellClicked", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for : indexPath) as! GameTableViewCell
        
        let quarterString = String(currentGameList[indexPath.row].Quarter)
        cell.awayTeamAbbrv.text = currentGameList[indexPath.row].awayTeam
        cell.homeTeamScore.text = String(currentGameList[indexPath.row].homeScore)
        cell.awayteamScore.text = String(currentGameList[indexPath.row].awayScore)
        cell.awayRecord.text = "(" + currentGameList[indexPath.row].awayRecord + ")"
        cell.homeRecord.text = "(" + currentGameList[indexPath.row].homeRecord + ")"
        cell.awayTeamLogo.image = currentGameList[indexPath.row].awayLogo
        cell.homeLogo.image = currentGameList[indexPath.row].homeLogo


        cell.homeTeamAbbrv.text = currentGameList[indexPath.row].homeTeam
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        if (currentGameList[indexPath.row].gameStatus == "in" ){
            if (currentGameList[indexPath.row].Quarter == 5){
                cell.quarter.text = "OT"
                cell.thLabel.isHidden = true
            }
            cell.finalLabel.isHidden = true
            cell.quarter.isHidden = false
            cell.thLabel.isHidden = false
            cell.currentTime.isHidden = false
            cell.quarter.text = String(currentGameList[indexPath.row].Quarter)
            cell.thLabel.text = determineQuarter(Quarter: currentGameList[indexPath.row].Quarter)
            cell.currentTime.text = currentGameList[indexPath.row].currentTime

        }
        else if(currentGameList[indexPath.row].gameStatus == "pre"){
            cell.thLabel.isHidden = true
            cell.quarter.isHidden = true
            cell.currentTime.isHidden = true
            cell.finalLabel.isHidden = false
            cell.finalLabel.text = currentGameList[indexPath.row].date
            cell.finalLabel.font = cell.finalLabel.font.withSize(14)
        }
        else if(currentGameList[indexPath.row].gameStatus == "post"){
        
            cell.thLabel.isHidden = true
            cell.quarter.isHidden = true
            cell.currentTime.isHidden = true
            cell.finalLabel.isHidden = false
            cell.finalLabel.text = "Final"
        }
        // add shadow on cell
 
        return cell
    }
    
    
}

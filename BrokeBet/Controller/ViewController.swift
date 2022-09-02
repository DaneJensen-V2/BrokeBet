//
//  ViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import UIKit
 
var rowSelected = 0
var gameNum = 0


class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var weekLabel: UILabel!
    let dummy = UITextField(frame: .zero)
    var selectedYear = ""
    var selectedWeek = ""
    var timer = Timer()
    let refreshControl = UIRefreshControl()

    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        toolbar.tintColor = .white
        toolbar.barTintColor = UIColor(named: "LogoColor")
        toolbar.isTranslucent = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let titleButton = UIBarButtonItem(title: "Select Year/Week", style: .plain, target: nil, action: nil)
        titleButton.isEnabled = false
        titleButton.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .disabled)
        let items = [flexSpace,titleButton, flexSpace2, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
   
        return toolbar
    }()
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var footballGame = footballMatch()
    let years = ["2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999"]
    let weeks = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    var weekPickerView = UIPickerView()
    
    let tempURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event="
    var gameURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard"
    var temp = ""
    var gameID = ""
    var fullURLAway = ""
    
    override func viewDidLoad() {
        view.addSubview(dummy)
        
       tableView.register(UINib(nibName : "GameTableViewCell", bundle: nil) , forCellReuseIdentifier: "gameCell")

        dummy.inputAccessoryView = doneToolbar
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundView = spinner
        weekPickerView.delegate = self
        weekPickerView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.frame = CGRect(x: refreshControl.bounds.origin.x,
                                      y: 50.0,
                                      width: refreshControl.bounds.size.width,
                                      height: refreshControl.bounds.size.height);
        refreshControl.superview?.sendSubviewToBack(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        loadData(){success in
            print("Loaded Data")
            self.updateUI()
        }
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
    
    @IBAction func weekSettings(_ sender: Any) {
        dummy.inputView = weekPickerView
        dummy.becomeFirstResponder()
    }
    @objc func refresh(_ sender: AnyObject) {
      
        loadData(){success in
            DispatchQueue.main.async {
                self.updateUI()
                self.refreshControl.endRefreshing()

            }
        }
    }
    func updateUI(){
        
            print("reloadingData")
        print(currentGameList.count)
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.separatorColor = .gray
            self.tableView.reloadData()
            
        }
          
    }
    @objc func doneButtonTapped(){
        print("Done Tapped")
        dummy.resignFirstResponder()
        temp = gameURL + "?dates=" + selectedYear + "&seasontype=2&week=" + selectedWeek
        print(temp)
        loadData(){success in
            self.updateUI()
        }
    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        loadData(){success in
            self.updateUI()
        }    }
    
    func loadData( completion: @escaping (Bool) -> Void){
        print("loadData")
        currentGameList = []
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            self.tableView.separatorColor = .clear
            self.tableView.reloadData()
            
        }
        spinner.startAnimating()
        if temp == ""{
            temp = gameURL
        }
        footballGame.performRequest(urlString: temp){success in
            self.loadStats(){success in
                completion(true)
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
    
    func loadStats( completion: @escaping (Bool) -> Void){
        var count = 0
        var overallCount = 0
        print("LOAD STATS RUN")
        let Stats = teamStats()
        let tempURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event="
        for game in currentGameList {
            let gameID = game.gameID
            let gameURL = tempURL + gameID
            
            Stats.performRequest(urlString: gameURL, count: count){success in
                overallCount += 1
                if (overallCount == currentGameList.count - 1){
                    completion(true)
                }
            }
            count += 1
            
        }
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGameList.count
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
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return years.count
        }
        if component == 1{
            return weeks.count
        }
        else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return years[row]
        }
        if component == 1{
            return weeks[row]
        }
        else{
            return ""
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selectedWeek = weeks[pickerView.selectedRow(inComponent: 1)]
         selectedYear = years[pickerView.selectedRow(inComponent: 0)]
        
        print("Year: \(selectedYear) Week: \(selectedWeek)")

    }
}

//
//  ViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import UIKit
 
var rowSelected = 0
var gameNum = 0


class ScoresViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weekLabel: UILabel!
    let dummy = UITextField(frame: .zero)
    var selectedYear = ""
    var selectedWeek = ""
    var loaded = false
    var timer = Timer()
    let refreshControl = UIRefreshControl()
    var myTimer:Timer!
    var myTimeInterval:TimeInterval = 10
    var tempGameList = currentGameList
    var selectedGame = 0
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
    var ScoreFetcher = scoreFetcher()
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
     //   tableView.backgroundView = spinner
        weekPickerView.delegate = self
        weekPickerView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.frame = CGRect(x: refreshControl.bounds.origin.x,
                                      y: 50.0,
                                      width: refreshControl.bounds.size.width,
                                      height: refreshControl.bounds.size.height);
        refreshControl.superview?.sendSubviewToBack(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        loadScores(showSpinner : true){success in
            print("Loaded Data")
            self.updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Appeared")
        myTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { (aTimer) in
            print("Timer Fired")
           // self.loadScores(showSpinner : false){success in
          //
         //       self.updateUI()
         //   }
        })
        
        if let selection = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selection , animated: true)
        }
        else {
            print("NO SELECTION")
        }
    }


        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            myTimer.invalidate()
        }
    
    @IBAction func weekSettings(_ sender: Any) {
        dummy.inputView = weekPickerView
        dummy.becomeFirstResponder()
    }
    @objc func refresh(_ sender: AnyObject) {
      
        loadScores(showSpinner : true){success in
            DispatchQueue.main.async {
                self.updateUI()
                self.refreshControl.endRefreshing()

            }
        }
    }
    func updateUI(){
        loaded = true
            print("reloadingData")
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
        loadScores(showSpinner : true){success in
            self.updateUI()
        }
        
    }
    
    func loadScores(showSpinner : Bool, completion: @escaping (Bool) -> Void){
        tempGameList = []
        for _ in bettingTableSections{
            tempGameList.append([])
        }
        overallCount = 0
        
        if showSpinner{
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            self.tableView.separatorColor = .clear
            self.tableView.reloadData()
            
            }
        }

        Task {
            do {
                let NFLGames = try await ScoreFetcher.fetchGames(from: scoreboardURLS[0])
                let NBAGames = try await ScoreFetcher.fetchGames(from: scoreboardURLS[1])
                let CFLGames = try await ScoreFetcher.fetchGames(from: scoreboardURLS[2])
                let MLBGames = try await ScoreFetcher.fetchGames(from: scoreboardURLS[3])

                print(NFLGames.events.count)
                print(NBAGames.events.count)
                print(CFLGames.events.count)
               print(MLBGames.events.count)

                let NFLGamesParsed = try await ScoreFetcher.parseGameResults(game: "NFL", data: NFLGames)
                let NBAGamesParsed = try await ScoreFetcher.parseGameResults(game: "NBA", data: NBAGames)
                let CFLGamesParsed = try await ScoreFetcher.parseGameResults(game: "", data: CFLGames)
                let MLBGamesParsed = try await ScoreFetcher.parseGameResults(game: "MLB", data: MLBGames)

                tempGameList[0] = NFLGamesParsed
                tempGameList[1] = NBAGamesParsed
               tempGameList[2] = CFLGamesParsed
                tempGameList[3] = MLBGamesParsed
                
                
                completion(true)
            }
            catch{
                print("Request failed with error : \(error)")
            }
        }
    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        loadScores(showSpinner : true){success in
            self.updateUI()
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
    
    /*
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
     */
}
extension ScoresViewController : UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !loaded{
            return 0
        }
        
        return tempGameList[selectedGame].count
        
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
        if !loaded {
            return cell
        }
        let currentGame = tempGameList[selectedGame][indexPath.row]
        
        
        
        let quarterString = String(currentGame.Quarter)
        cell.awayTeamAbbrv.text = currentGame.awayTeam
        cell.homeTeamScore.text = String(currentGame.homeScore)
        cell.awayteamScore.text = String(currentGame.awayScore)
        cell.awayRecord.text = "(" + currentGame.awayRecord + ")"
        cell.homeRecord.text = "(" + currentGame.homeRecord + ")"
        cell.awayTeamLogo.image = currentGame.awayLogo
        cell.homeLogo.image = currentGame.homeLogo


        cell.homeTeamAbbrv.text = currentGame.homeTeam
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        if (currentGame.gameStatus == "in" ){
            if (currentGame.Quarter == 5){
                cell.quarter.text = "OT"
                cell.thLabel.isHidden = true
            }
            cell.finalLabel.isHidden = true
            cell.quarter.isHidden = false
            cell.thLabel.isHidden = false
            cell.currentTime.isHidden = false
            cell.quarter.text = String(currentGame.Quarter)
            cell.thLabel.text = determineQuarter(Quarter: currentGame.Quarter)
            cell.currentTime.text = currentGame.currentTime

        }
        else if(currentGame.gameStatus == "pre"){
            cell.thLabel.isHidden = true
            cell.quarter.isHidden = true
            cell.currentTime.isHidden = true
            cell.finalLabel.isHidden = false
            cell.finalLabel.text = currentGame.date
            cell.finalLabel.font = cell.finalLabel.font.withSize(14)
        }
        else if(currentGame.gameStatus == "post"){
        
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
extension ScoresViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bettingTableSections.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
           let item = bettingTableSections[indexPath.row]
               var itemSize = item.size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: "FrancophilSans", size: 18)!
               ])
           itemSize.height = 35
           itemSize.width += 60
               return itemSize
           
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected at \(indexPath.row)")
        if let cell = collectionView.cellForItem(at: indexPath) as? ScoreCollectionViewCell {
            if cell.backgroundColor == UIColor(named : "LogoColor"){
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                cell.backgroundColor = UIColor(named : "DarkLogoColor")
                let previousIndex = IndexPath(row: selectedGame, section: 0)
                let previousCell = collectionView.cellForItem(at: previousIndex) as? ScoreCollectionViewCell
                previousCell?.backgroundColor = UIColor(named : "LogoColor")
                selectedGame = indexPath.row
                tableView.reloadData()
            }
            
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ScoreCollectionViewCell
        cell.layer.cornerRadius = 15
        if indexPath.row == selectedGame{
            cell.backgroundColor = UIColor(named : "DarkLogoColor")
        }
        cell.name.text = bettingTableSections[indexPath.row]
        cell.image.image = UIImage(named: bettingTableSections[indexPath.row] + "-Logo") ?? UIImage(named : "football")!
        cell.addShadow()
        return cell
    }
    
    
}
extension ScoresViewController : UIPickerViewDelegate, UIPickerViewDataSource{
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

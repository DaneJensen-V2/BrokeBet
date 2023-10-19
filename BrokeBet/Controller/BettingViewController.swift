//
//  BettingViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/17/21.
//

import UIKit
import Firebase
var ScoreFetcher = scoreFetcher()
var BettingFetcher = bettingFetcher()
var timer = Timer()
var runNumber2 = 0
let db = Firestore.firestore()
var overallCount = 0
var bettingCount = 0
var balance = 1000
var currentUser : BBUser = BBUser(UserID: "", firstName: "", lastName: "", currentBalance: -1, activeBets: [], closedBets: [], Bets: 0, Won: 0, Lost: 0, Earned: 0)
var tempGameList : [[MatchupData]] = []
var signedIn : Bool = false
let group = DispatchGroup()
var requestDone = true
var bettingDone = false
var tableData : [[betDataForTable]] = []


let bettingTableSections = ["NFL", "NBA", "College Football", "MLB"]
let summaryURLS = ["https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event=",
                   "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/summary?event=",
               "https://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?event=",
                   "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/summary?event="
                    ]

let scoreboardURLS = ["https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard",
                      "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard",
                      "https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard",
                      "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard"

                      ]


class BettingViewController: UIViewController, UITableViewDelegate {
    let db = Firestore.firestore()
    
    @IBOutlet weak var parlayButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var bettingTable: UITableView!
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        typealias FinishedMethod = ()
        for _ in bettingTableSections{
            tableData.append([])
            tempGameList.append([])
        }
        bettingTable.delegate = self
        bettingTable.dataSource = self
        parlayButton.layer.cornerRadius = 10
        NotificationCenter.default.addObserver(self, selector: #selector(showButton), name: NSNotification.Name(rawValue: "parlay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("reloadTable"), object: nil)
        bettingTable.sectionHeaderTopPadding = 5
        
        let checkUser = Auth.auth().currentUser
        
        if (checkUser != nil) {
            signedIn = true
            
        } else {
            signedIn = false
            balanceLabel.text = "$" + String("--")
            
        }
        bettingTable.separatorStyle = .none
        parlayButton.titleLabel!.lineBreakMode = .byWordWrapping
        parlayButton.titleLabel!.numberOfLines = 2
        parlayButton.titleLabel!.textAlignment = .center
        let pan = UIPanGestureRecognizer(target: self, action: #selector(BettingViewController.panButton(pan:)))
        parlayButton.addGestureRecognizer(pan)
        bettingTable.register(UINib(nibName: "bettingTableHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "bettingTableHeader")
        loadDataBetting()
        
        bettingTable.register(UINib(nibName : "BettingTableViewCell", bundle: nil) , forCellReuseIdentifier: "bettingCell")
        
        if Auth.auth().currentUser != nil {
            print("USER IS LOGGED IN")
            loadCurrentUser(user : checkUser!)
            
        } else {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    print("SIGNED IN")
                    self.loadCurrentUser(user : user)
                    
                    print(user.uid)
                    
                } else {
                    print("NOT SIGNED IN")
                }
            }        }
        
        
        
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if(signedIn == false){
                self.balanceLabel.text = "$" + String("---")
                
            }
            else if(currentUser.currentBalance == -1){
                self.balanceLabel.text = "$" + String("---")
                
            }
            else{
                self.balanceLabel.text = "$" + String(currentUser.currentBalance)
                if(currentUser.currentBalance == 0){
                    self.balanceLabel.textColor = .red
                    timer.invalidate()
                    
                }
                
            }
        }
        let timer3 = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { timer3 in
            if(signedIn == true){
                self.checkAllBets()
                
            }
        }
       
        
        let timer2 = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer2 in
            if(signedIn == false){
                self.loginButton.setTitle("LOGIN", for: .normal)
                self.balanceLabel.text = "$" + String("---")
                
            }
            else if(signedIn == true){
                self.loginButton.setTitle("LOGOUT", for: .normal)
                
                
            }
            else{
                if(currentUser.currentBalance == -1 ){
                    self.balanceLabel.text = "$" + String("---")
                    
                }
                else{
                    self.balanceLabel.text = "$" + String(currentUser.currentBalance)
                    if(currentUser.currentBalance == 0){
                        self.balanceLabel.textColor = .red
                        timer.invalidate()
                        
                    }
                }
            }
        }
    }
    
    @objc func reloadTable(){
        DispatchQueue.main.async {
            self.bettingTable.reloadData()
        }
    }
    func loadCurrentUser(user : User){
        let docRef = db.collection("Users").document(user.uid)
        
        docRef.getDocument { (document, error) in
            
            let result = Result {
                try document?.data(as: BBUser.self)
            }
            switch result {
            case .success(let loadedUser):
                if let loadedUser = loadedUser {
                    currentUser = loadedUser
                    
                    self.balanceLabel.text = "$" + String(currentUser.currentBalance)
                    
                    print("Loaded User")
                    print(currentUser.UserID)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateStats"), object: nil)

                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding city: \(error)")
            }
        }
    }
    @objc func panButton(pan: UIPanGestureRecognizer) {
    }
    func loadDataBetting(){
        currentGameList = []
        for _ in bettingTableSections{
            currentGameList.append([])
        }
        overallCount = 0
        bettingTable.backgroundView = spinner
        spinner.startAnimating()
        bettingTable.tableHeaderView?.isHidden = true
        bettingTable.separatorColor = .clear

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
                 
        
                currentGameList[0] = NFLGamesParsed
                
                currentGameList[1] = NBAGamesParsed
                currentGameList[2] = CFLGamesParsed
                currentGameList[3] = MLBGamesParsed
                
                
                for list in currentGameList{
                    overallCount += list.count
                }
                
                loadBetting()
            }
            catch{
                print("Request failed with error : \(error)")
            }
        }
    }
    func loadBetting(){
        var listCount = 0
        for list in currentGameList{
            var gameCount = 0
            for game in list{
                fetchBettingOdds(Game : game, section: listCount, gameNum: gameCount)
                gameCount += 1
            }
            listCount += 1
        }
    }
    func fetchBettingOdds(Game : MatchupData, section : Int, gameNum : Int){
        Task{

        let bettingData = try await BettingFetcher.fetchBettingData(from: summaryURLS[section], ID: Game.gameID)
        currentGameList[section][gameNum].bettingData = bettingData
        bettingCount += 1
          //  print("Betting Count: \(bettingCount) Overall Count \(overallCount)")
            if bettingCount == overallCount{
                finishedLoading()
                return
            }
        }
    }
    
    @IBAction func loginButtonPushed(_ sender: UIButton) {
        if(signedIn == true){
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

                   // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive, handler: { action in

                signedIn = false
                self.logout()

            }))
                   alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
       

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
         
        }
        else{
            print("Login")
            let vc = storyboard?.instantiateViewController(identifier: "LoginView")
            presentBottomHalfModal(vc!, animated: true, completion: nil)
        }
        
    }
    func determineActiveGames(){
        print("Determining")
        activeGames = []
        for _ in bettingTableSections{
            print("APPENDING")
            activeGames.append([])
        }
        var section = 0
        for gameList in currentGameList{
            for game in gameList{
                if(game.gameStatus == "pre" || game.gameStatus == "post"){
                    activeGames[section].append(game);
                }
            }
            section += 1
        }
    }
    
    func finishedLoading(){
        self.convertTempToMain()
        self.determineActiveGames()
        
        if(activeGames.count == 0 ){
            DispatchQueue.main.async {

            }
            return
        }
        else{
            self.convertToTableStruct(){success in
                DispatchQueue.main.async(execute: { () -> Void in
                  
                    self.bettingTable.isHidden = false
                    self.bettingTable.separatorColor = .gray
                    self.spinner.stopAnimating()
                    self.bettingTable.reloadData()
                })
            }
            
            
        }
    }
    
    func checkAllBets(){/*
        for bet in currentUser.activeBets{
            if bet.isParlay{
                for component in bet.parlayComponents{
                    
                }
            }
            for game in currentGameList {
                if (bet.betGameID == game.gameID){
                    if(game.gameStatus == "post"){
                         checkForWin(bet: bet, game: game)
                            }
                        }
                    }
                
        }
            
         */
    }
    @objc func showButton(){
        UIView.animate(withDuration: 0.3) {
            self.parlayButton.alpha = 1.0
           }
        if parlayComponents.isEmpty {
            UIView.animate(withDuration: 0.3) {
                self.parlayButton.alpha = 0
                creatingParlay = false
                firstClick = true

               }
        }
        else{
        updateButtonText(){odds in
            let count = parlayComponents.count
            let pickAttributes = [ NSAttributedString.Key.font: UIFont(name: "FrancophilSans", size: 18.0)!, NSAttributedString.Key.foregroundColor : UIColor.white  ]
            var pickString = NSMutableAttributedString()
            
            if count > 1{
                 pickString = NSMutableAttributedString(string: "\(count) PICKS\n", attributes: pickAttributes )

            }
            else{
                 pickString = NSMutableAttributedString(string: "\(count) PICK\n", attributes: pickAttributes )

            }
            
            let oddsAttributes = [ NSAttributedString.Key.font: UIFont(name: "FrancophilSans-Bold", size: 20.0)!, NSAttributedString.Key.foregroundColor : UIColor.white  ]
            let oddsString = NSMutableAttributedString(string: odds, attributes: oddsAttributes )
            
            let fullString = NSMutableAttributedString()
            
            
            fullString.append(pickString)
            fullString.append(oddsString)

            print(fullString.string)
            let myIndexPath = IndexPath(row: buttonIndex[0], section: 0)
            var indexArray : [IndexPath] = []
            indexArray.append(myIndexPath)
            if firstClick{
            self.bettingTable.reloadRows(at: indexArray, with: .none)
            }
            self.parlayButton.setAttributedTitle(fullString, for: .normal)
        }
        }
        
    }
 
    func updateButtonText(completion: @escaping (String) -> Void){
        var decimalOdds : [Double] = []
        if parlayComponents.isEmpty{
            completion("")
        }
        else{
            for bet in parlayComponents{
                let oddsString = bet.odds
                if oddsString.hasPrefix("-"){
                    let oddsInt = Int(oddsString)! * -1
                    let decimalOdd = (100.0 / Double(oddsInt)) + 1.0
                    decimalOdds.append(decimalOdd)
                }
                else{
                    let oddsInt = Int(oddsString)!
                    let decimalOdd = (Double(oddsInt) / 100) + 1.0
                    decimalOdds.append(decimalOdd)
                }
            }
            var total = 1.0
            for decimal in decimalOdds{
                total = total * decimal
            }
            if total < 2{
                let temp = -100.0 / (total - 1.0)
                let roundedString = String(format: "%.0f", temp)
                completion(roundedString)
                
            }
            else{
                let temp = (total - 1.0) * 100.0
                let roundedString = String(format: "%.0f", temp)
                completion("+" + roundedString)
            }
        }
        
    }
  
    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func convertTempToMain(){
        var list = 0
        for betList in tempGameList{
            for bet in betList{
                var gameNum = 0
            for game in currentGameList[list]{
                if game.gameID == bet.gameID{
                    print()
                    currentGameList[list][gameNum].bettingData = bet.bettingData
                }
                gameNum += 1
            }
        }
            list += 1
        }
    }
    
}

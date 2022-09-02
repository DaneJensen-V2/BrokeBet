//
//  BettingViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/17/21.
//

import UIKit
import Firebase
var footballGame = footballMatch()
var timer = Timer()
var runNumber2 = 0
let db = Firestore.firestore()

var balance = 1000
var currentUser : BBUser = BBUser(UserID: "", firstName: "", lastName: "", currentBalance: -1, activeBets: [], closedBets: [], Bets: 0, Won: 0, Lost: 0, Earned: 0)
var signedIn : Bool = false
let group = DispatchGroup()
var requestDone = true
var bettingDone = false
var tableData : [betDataForTable] = []

class BettingViewController: UIViewController, UITableViewDelegate {
    let db = Firestore.firestore()
    
    @IBOutlet weak var parlayButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var bettingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typealias FinishedMethod = ()
        
        bettingTable.delegate = self
        bettingTable.dataSource = self
        parlayButton.layer.cornerRadius = 10
        NotificationCenter.default.addObserver(self, selector: #selector(showButton), name: NSNotification.Name(rawValue: "parlay"), object: nil)

        let checkUser = Auth.auth().currentUser
        
        if (checkUser != nil) {
            signedIn = true
            
        } else {
            signedIn = false
            balanceLabel.text = "$" + String("--")
            
        }
        parlayButton.titleLabel!.lineBreakMode = .byWordWrapping
        parlayButton.titleLabel!.numberOfLines = 2
        parlayButton.titleLabel!.textAlignment = .center
        let pan = UIPanGestureRecognizer(target: self, action: #selector(BettingViewController.panButton(pan:)))
        parlayButton.addGestureRecognizer(pan)
        
        loadDataBetting(){success in
            if(activeGames.count == 0 ){
                DispatchQueue.main.async {
                    self.bettingTable.isHidden = true

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
        let timer3 = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer3 in
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
                    print(currentUser.currentBalance)
                    
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
        /*
        if pan.state == .began {
            let buttonY = parlayButton.center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            button.center = buttonCenter // restore button center
        } else {
            let location = pan.location(in: view) // get pan location
            button.center = location // set button to where finger is
        }
         */
    }
    func loadDataBetting(completion: @escaping (Bool) -> Void){
        currentGameList = []
        
        bettingTable.backgroundView = spinner
        spinner.startAnimating()
        bettingTable.separatorColor = .clear
        
        
        footballGame.performRequest(urlString: footballGame.gameURL){success in
            self.loadBettingOdds(){success in
                self.determineActiveGames()
                completion(true)
            
            }
            
        }
        
    }
    
    @IBAction func loginButtonPushed(_ sender: UIButton) {
        if(signedIn == true){
            signedIn = false
            logout()
        }
        else{
            print("Login")
            let vc = storyboard?.instantiateViewController(identifier: "LoginView")
            presentBottomHalfModal(vc!, animated: true, completion: nil)
        }
        
    }
    func determineActiveGames(){
        for game in currentGameList{
            if(game.gameStatus == "pre" || game.gameStatus == "post"){
                activeGames.append(game);
            }
        }
    }
    func checkAllBets(){
        for bet in currentUser.activeBets{
            print("Bet Checked")
            if(bet.typeOfBet == "Spread"){
                print("Spread Checked")
                for game in currentGameList {
                    if (bet.betGameID == game.gameID){
                        if(game.gameStatus == "post"){
                            checkForWin(bet: bet, game: game)
                        }
                    }
                }
            }
            else if(bet.typeOfBet == "Moneyline"){
                print("MoneyLine Checked")
                for game in currentGameList {
                    if (bet.betGameID == game.gameID){
                        if(game.gameStatus == "post"){
                            checkForWin(bet: bet, game: game)
                        }
                    }
                }
            }
            else if(bet.typeOfBet == "Over/Under"){
                print("Over/Under Checked")
                for game in currentGameList {
                    if (bet.betGameID == game.gameID){
                        if(game.gameStatus == "post"){
                            checkForWin(bet: bet, game: game)
                        }
                    }
                }
            }
        }
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
        print(parlayComponents)
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
    func checkForWin(bet : UserBet, game : MatchupData){
        var spreadInt = 0.0
        if(bet.typeOfBet == "Spread"){
            if(bet.teamID == "Away"){
                if(bet.spread.hasPrefix("+")){
                    
                    let stringSize = bet.spread.count
                    
                    let substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "+", with: "")
                    spreadInt = Double(substr)!
                    
                    if(Int(game.awayScore)! > Int(game.homeScore)! || abs(Double((Int(game.homeScore)! - Int(game.awayScore)!))) <= spreadInt){
                        betWon(bet: bet, game: game)
                    }
                    else{
                        betLost(bet: bet, game: game)
                    }
                }
                else if(bet.spread.hasPrefix("-")){
                    var stringSize = bet.spread.count
                    
                    var substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "-", with: "")
                    print(substr)
                    spreadInt = Double(substr)!
                    
                    if(Int(game.awayScore)! > Int(game.homeScore)! && abs(Double((Int(game.awayScore)! - Int(game.homeScore)!))) >= spreadInt){
                        betWon(bet: bet, game: game)
                    }
                    else{
                        betLost(bet: bet, game: game)
                    }
                }
            }
            else if (bet.teamID == "Home"){
                if(bet.spread.hasPrefix("+")){
                    
                    var stringSize = bet.spread.count
                    
                    var substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "+", with: "")
                    spreadInt = Double(substr)!
                    
                    if(Int(game.homeScore)! > Int(game.awayScore)! || abs(Double((Int(game.awayScore)! - Int(game.homeScore)!))) <= spreadInt){
                        betWon(bet: bet, game: game)
                    }
                    else{
                        betLost(bet: bet, game: game)
                    }
                }
                else if(bet.spread.hasPrefix("-")){
                    var stringSize = bet.spread.count
                    
                    var substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "-", with: "")
                    spreadInt = Double(substr)!
                    
                    if(Int(game.homeScore)! > Int(game.awayScore)! && abs(Double((Int(game.homeScore)! - Int(game.awayScore)!))) >= spreadInt){
                        betWon(bet: bet, game: game)
                    }
                    else{
                        betLost(bet: bet, game: game)
                    }
                    
                }
            }
            
            
        }
        else if(bet.typeOfBet == "Moneyline"){
            if(bet.teamID == "Home"){
                if(game.homeScore > game.awayScore){
                    betWon(bet: bet, game: game)
                }
                else{
                    betLost(bet: bet, game: game)
                }
            }
            else if(bet.teamID == "Away"){
                if(game.awayScore > game.homeScore){
                    betWon(bet: bet, game: game)
                }
                else{
                    betLost(bet: bet, game: game)
                }
            }
            
        }
        else if(bet.typeOfBet == "Over/Under"){
            if(bet.spread.hasPrefix("O")){
                var stringSize = bet.spread.count
                
                var substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "O", with: "")
                stringSize = substr.count
                
                substr = substr.substring(with: 1..<stringSize).replacingOccurrences(of: " ", with: "")
                let totalInt = Double(substr)!
                
                if(Double(Int(game.awayScore)! + Int(game.homeScore)!) > totalInt){
                    betWon(bet: bet, game: game)
                }
                else{
                    betLost(bet: bet, game: game)
                }
            }
            else if (bet.spread.hasPrefix("U")){
                var stringSize = bet.spread.count
                
                var substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "U", with: "")
                
                stringSize = substr.count
                
                substr = substr.substring(with: 1..<stringSize).replacingOccurrences(of: " ", with: "")
                let totalInt = Double(substr)!
                
                if(Double(Int(game.awayScore)! + Int(game.homeScore)!) < totalInt){
                    betWon(bet: bet, game: game)
                }
                else {
                    betLost(bet: bet, game: game)
                }
            }
        }
        
    }
    
    
    func betWon(bet : UserBet, game : MatchupData){
        print("Congrats, you won a bet!")
        var i = 0
        let user = Auth.auth().currentUser
        let currentuserID = user?.uid
        let currentUserDB = self.db.collection("Users").document(currentuserID!)
        
        currentUser.currentBalance = currentUser.currentBalance + bet.potentialPayout
        
        for bet in currentUser.activeBets{
            if(currentUser.activeBets[i].amountBet == bet.amountBet && currentUser.activeBets[i].betGameID == bet.betGameID && currentUser.activeBets[i].potentialPayout == bet.potentialPayout && currentUser.activeBets[i].typeOfBet == bet.typeOfBet){
                
                currentUser.activeBets.remove(at: i)
                break
            }
            i += 1
        }
        print(currentUser.activeBets.count)
        var wonBet = bet
        wonBet.outcome = "Won"
        print("REMOVED FROM DB")
        
        let encoded: [String: Any]
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encoded = try Firestore.Encoder().encode(bet)
        } catch {
            // encoding error
            print(error)
            return
        }
        let encoded2: [String: Any]
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encoded2 = try Firestore.Encoder().encode(wonBet)
        } catch {
            // encoding error
            print(error)
            return
        }
        currentUser.Earned = currentUser.Earned + Double(bet.potentialPayout) - Double(bet.amountBet)
        currentUser.Won += 1
        currentUser.Bets = currentUser.Bets + 1
        currentUserDB.updateData([
            "Bets" : currentUser.Bets,
            "Earned" : currentUser.Earned,
            "Won" : currentUser.Won,
            "currentBalance": currentUser.currentBalance,
            "Active Bets": FieldValue.arrayRemove([encoded]),
            "Closed Bets" : FieldValue.arrayUnion([encoded2])

        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                currentUser.closedBets.append(bet)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateStats"), object: nil)

            }
        }
    }
    func convertToTableStruct(completion: @escaping (Bool)->Void){
        do{
        for game in activeGames{
            var tempTableData = betDataForTable(title: "", date: "", homeTeamImage: UIImage(named: "AppIcon")!, awayTeamImage:  UIImage(named: "AppIcon")!, awayTeamName: "", homeTeamName: "", spreadAway: "", moneyAway: "", totalAway: "", spreadHome: "", moneyHome: "", totalHome: "")
            tempTableData.awayTeamImage = game.awayLogo!
            tempTableData.homeTeamImage = game.homeLogo!
            tempTableData.awayTeamName = game.awayTeamLong
            tempTableData.homeTeamName = game.homeTeamLong
            tempTableData.title = game.awayTeam + " " + game.awayTeamLong + " at " + game.homeTeam + " " + game.homeTeamLong
            tempTableData.date = game.datePrint.uppercased()
            var symbol2 = ""
            if(game.bettingData.awaySpread > 0){
                symbol2 = "+"
                tempTableData.spreadAway = (symbol2 + String(game.bettingData.awaySpread) + "\n" + String(Int(game.bettingData.spreadOddsAway)))
            }
            else if (game.bettingData.awaySpread == 0){
                tempTableData.spreadAway = ( "PICK" + "\n" + String(Int(game.bettingData.spreadOddsAway)))
            }
            else {
                symbol2 = ""
                tempTableData.spreadAway = (symbol2 + String(game.bettingData.awaySpread) + "\n" + String(Int(game.bettingData.spreadOddsAway)))
            }
            if(game.bettingData.homeSpread > 0){
                symbol2 = "+"
                tempTableData.spreadHome = (symbol2 + String(game.bettingData.homeSpread) + "\n" + String(Int(game.bettingData.spreadOddsHome)))
            }
            else if (game.bettingData.awaySpread == 0){
                tempTableData.spreadHome = ( "PICK" + "\n" + String(Int(game.bettingData.spreadOddsHome)))
            }
            else {
                symbol2 = ""
                tempTableData.spreadHome = (symbol2 + String(game.bettingData.homeSpread) + "\n" + String(Int(game.bettingData.spreadOddsHome)))
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

            tempTableData.totalAway = ("O " + String(game.bettingData.overUnder) + "\n" + String("-110"))
            
           tableData.append(tempTableData)

        }
            completion(true)
        }
    }
    func betLost(bet : UserBet, game : MatchupData){
        print("Sorry, you lost a bet")
        var i = 0
        let user = Auth.auth().currentUser
        let currentuserID = user?.uid
        let currentUserDB = self.db.collection("Users").document(currentuserID!)
        
        for bet in currentUser.activeBets{
            if(currentUser.activeBets[i].amountBet == bet.amountBet && currentUser.activeBets[i].betGameID == bet.betGameID && currentUser.activeBets[i].potentialPayout == bet.potentialPayout && currentUser.activeBets[i].typeOfBet == bet.typeOfBet){
                
                currentUser.activeBets.remove(at: i)
                break
            }
            i += 1
        }
        currentUser.Lost += 1
        currentUser.Earned = currentUser.Earned - Double(bet.amountBet)
        currentUser.Bets = currentUser.Bets + 1

        print(currentUser.activeBets.count)
        var lostBet = bet
        lostBet.outcome = "Lost"
        print("REMOVED FROM DB")
        
        let encoded: [String: Any]
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encoded = try Firestore.Encoder().encode(bet)
        } catch {
            // encoding error
            print(error)
            return
        }
        let encoded2: [String: Any]
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encoded2 = try Firestore.Encoder().encode(lostBet)
        } catch {
            // encoding error
            print(error)
            return
        }
        currentUserDB.updateData([
            "Bets" : currentUser.Bets,
            "Earned" : currentUser.Earned,
            "Lost" : currentUser.Lost,
            "Active Bets": FieldValue.arrayRemove([encoded]),
            "Closed Bets" : FieldValue.arrayUnion([encoded2])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                currentUser.closedBets.append(bet)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateStats"), object: nil)

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
    
    func loadBettingOdds(completion: @escaping (Bool) -> Void){
        print("Total Events: \(totalEvents)")
        var count = 0
        var overallCount = 0
        for game in currentGameList{
            
            let Betting = Betting()
            let tempURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event="
            let gameID = game.gameID
            let gameURL = tempURL + gameID
            
            
            
            Betting.performRequest(urlString: gameURL, count: count){success in
                overallCount += 1
                if (overallCount == totalEvents ){
                    completion(true)
                }
            }
            
           count += 1
        }
        
    }
}
    


extension BettingViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return tableData.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
     return 208
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = bettingTable.dequeueReusableCell(withIdentifier: "bettingCell", for : indexPath) as! BettingTableViewCell
        cell.index = indexPath.row
        cell.awayTeamImage.image = tableData[indexPath.row].awayTeamImage
        cell.homeTeamImage.image = tableData[indexPath.row].homeTeamImage

        cell.awayTeamName.text = tableData[indexPath.row].awayTeamName
        cell.homeTeamName.text = tableData[indexPath.row].homeTeamName
        
        cell.title.text = tableData[indexPath.row].title

        cell.date.text = tableData[indexPath.row].date
        
        cell.spreadAway.setTitle(tableData[indexPath.row].spreadAway, for: .normal)
        cell.spreadAway.titleLabel?.textAlignment = .center
        
        cell.spreadHome.setTitle(tableData[indexPath.row].spreadHome, for: .normal)
        cell.spreadHome.titleLabel?.textAlignment = .center
        
     
        cell.moneyAway.setTitle(tableData[indexPath.row].moneyAway, for: .normal)
        
        cell.moneyHome.setTitle(tableData[indexPath.row].moneyHome, for: .normal)

        cell.totalAway.setTitle(tableData[indexPath.row].totalAway, for: .normal)
        cell.totalAway.titleLabel?.textAlignment = .center
        
        cell.totalHome.setTitle(tableData[indexPath.row].totalHome, for: .normal)
        cell.totalHome.titleLabel?.textAlignment = .center
        
        
        let buttons = tableData[indexPath.row].selectedButtons
        
        if buttons[0]{
            cell.spreadAway.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.spreadAway.backgroundColor = UIColor(named: "lightGreen")

        }
        if buttons[1]{
            cell.moneyAway.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.moneyAway.backgroundColor = UIColor(named: "lightGreen")

        }
        if buttons[2]{
            cell.totalAway.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.totalAway.backgroundColor = UIColor(named: "lightGreen")

        }
        if buttons[3]{
            cell.spreadHome.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.spreadHome.backgroundColor = UIColor(named: "lightGreen")

        }
        if buttons[4]{
            cell.moneyHome.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.moneyHome.backgroundColor = UIColor(named: "lightGreen")

        }
        if buttons[5]{
            cell.totalHome.backgroundColor = UIColor(named: "darkerGreen")
        }
        else{
            cell.totalHome.backgroundColor = UIColor(named: "lightGreen")

        }
     
    
        return cell
    }
}

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
var currentUser : BBUser = BBUser(UserID: "", firstName: "", lastName: "", currentBalance: -1, activeBets: [], allBets: [], Bets: 0, Won: 0, Lost: 0, Earned: 0)
var signedIn : Bool = false
let group = DispatchGroup()
var requestDone = true
var bettingDone = false


class BettingViewController: UIViewController, UITableViewDelegate {
    let db = Firestore.firestore()

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var bettingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typealias FinishedMethod = ()

        bettingTable.delegate = self
        bettingTable.dataSource = self

        
        let checkUser = Auth.auth().currentUser
        
        if (checkUser != nil) {
            signedIn = true
            
        } else {
            signedIn = false
        balanceLabel.text = "$" + String("--")

        }
        
        
        loadDataBetting();
        
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
                self.loginButton.setTitle("Login", for: .normal)
                self.balanceLabel.text = "$" + String("---")

            }
            else if(signedIn == true){
                self.loginButton.setTitle("Logout", for: .normal)


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

    func loadDataBetting(){
        currentGameList = []

        footballGame.performRequest(urlString: footballGame.gameURL)
        
        bettingTable.backgroundView = spinner
        spinner.startAnimating()
        bettingTable.separatorColor = .clear
        var hasRun = false
        
        if(hasRun == false){
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
                
        if (currentGameList.count == totalEvents){
            self.spinner.stopAnimating()
            self.bettingTable.isHidden = false
            self.bettingTable.dataSource = self
            self.bettingTable.delegate = self
            self.bettingTable.separatorColor = .gray
            self.bettingTable.register(UINib(nibName : "BettingTableViewCell", bundle: nil) , forCellReuseIdentifier: "bettingCell")

            DispatchQueue.main.async(execute: { () -> Void in
                            self.bettingTable.reloadData()

                        })
            hasRun = true

        }
            
                if(hasRun == true){
                    print("Ran Start")
                    runNumber2 = 0
                    
                        self.loadBettingOdds()
                    
                        self.determineActiveGames()
                    while (bettingDone == false){
                        
                    }

                        if(activeGames.count == 0 ){
                            self.bettingTable.isHidden = true
                            timer.invalidate()
                            return
                        }
                    timer.invalidate()
                    
                    
                
        
                
        }
        }
        )}
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
        bettingDone = true
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
    func checkForWin(bet : UserBet, game : MatchupData){
        var spreadInt = 0.0
        if(bet.typeOfBet == "Spread"){
            if(bet.teamID == "Away"){
                if(bet.spread.hasPrefix("+")){

                var stringSize = bet.spread.count

                var substr = bet.spread.substring(with: 1..<stringSize).replacingOccurrences(of: "+", with: "")
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
        
        currentUserDB.updateData([
            "currentBalance": currentUser.currentBalance,
            "Active Bets": FieldValue.arrayRemove([encoded])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
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
        print(currentUser.activeBets.count)
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
        
        currentUserDB.updateData([
            "Active Bets": FieldValue.arrayRemove([encoded])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
    
     func loadBettingOdds()
    {
        for game in currentGameList{

            let Betting = Betting()
            let tempURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event="
            let gameID = game.gameID
            let gameURL = tempURL + gameID

            while(requestDone == false){
                
            }
            
            Betting.performRequest(urlString: gameURL)
            requestDone = false
            
            
        }
        print("TEST")
        usleep(700000)
    }

}


extension BettingViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return activeGames.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
     return 208
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = bettingTable.dequeueReusableCell(withIdentifier: "bettingCell", for : indexPath) as! BettingTableViewCell
        cell.awayTeamImage.image = activeGames[indexPath.row].awayLogo
        cell.homeTeamImage.image = activeGames[indexPath.row].homeLogo
        cell.gameID.text = activeGames[indexPath.row].gameID

        cell.awayTeamName.text = activeGames[indexPath.row].awayTeamLong
        cell.homeTeamName.text = activeGames[indexPath.row].homeTeamLong
        
        cell.title.text = activeGames[indexPath.row].awayTeam + " " +  activeGames[indexPath.row].awayTeamLong + " at " +  activeGames[indexPath.row].homeTeam + " " + activeGames[indexPath.row].homeTeamLong

        cell.date.text = activeGames[indexPath.row].datePrint.uppercased()
        
        var symbol2 = ""
        if(activeGames[indexPath.row].bettingData.awaySpread > 0){
            symbol2 = "+"
            cell.spreadAway.setTitle(symbol2 + String(activeGames[indexPath.row].bettingData.awaySpread) + "\n" + String(Int(activeGames[indexPath.row].bettingData.spreadOddsAway)), for: .normal)
            cell.spreadAway.titleLabel?.textAlignment = .center
        }
        else if (activeGames[indexPath.row].bettingData.awaySpread == 0){
            cell.spreadAway.setTitle( "PICK" + "\n" + String(Int(activeGames[indexPath.row].bettingData.spreadOddsAway)), for: .normal)
            cell.spreadAway.titleLabel?.textAlignment = .center
        }
        else {
            symbol2 = ""
            cell.spreadAway.setTitle(symbol2 + String(activeGames[indexPath.row].bettingData.awaySpread) + "\n" + String(Int(activeGames[indexPath.row].bettingData.spreadOddsAway)), for: .normal)
            cell.spreadAway.titleLabel?.textAlignment = .center
        }
       

        var symbol = ""
        if(activeGames[indexPath.row].bettingData.moneyLineAway > 0){
            symbol = "+"
            
        }
        
        else {
            symbol = ""
            
        }
        
        cell.moneyAway.setTitle(symbol + String(activeGames[indexPath.row].bettingData.moneyLineAway), for: .normal)
        
        
        cell.totalAway.setTitle("O " + String(activeGames[indexPath.row].bettingData.overUnder) + "\n" + String("-110"), for: .normal)
        cell.totalAway.titleLabel?.textAlignment = .center
        
        if(activeGames[indexPath.row].bettingData.homeSpread > 0){
            symbol2 = "+"
            cell.spreadHome.setTitle(symbol2 + String(activeGames[indexPath.row].bettingData.homeSpread) + "\n" + String(Int(activeGames[indexPath.row].bettingData.spreadOddsHome)), for: .normal)
            cell.spreadHome.titleLabel?.textAlignment = .center
        }
        else if (activeGames[indexPath.row].bettingData.homeSpread == 0){
            cell.spreadHome.setTitle("PICK" + "\n" + String(Int(activeGames[indexPath.row].bettingData.spreadOddsHome)), for: .normal)
            cell.spreadHome.titleLabel?.textAlignment = .center
        }
        else {
            symbol2 = ""
            cell.spreadHome.setTitle(symbol2 + String(activeGames[indexPath.row].bettingData.homeSpread) + "\n" + String(Int(activeGames[indexPath.row].bettingData.spreadOddsHome)), for: .normal)
            cell.spreadHome.titleLabel?.textAlignment = .center
        }
 
        
        if(activeGames[indexPath.row].bettingData.moneyLineHome > 0){
            symbol = "+"
        }
        else {
            symbol = ""
        }
        cell.moneyHome.setTitle(symbol + String(activeGames[indexPath.row].bettingData.moneyLineHome), for: .normal)
        cell.moneyHome.titleLabel?.textAlignment = .center

        
        cell.totalHome.setTitle("U " + String(activeGames[indexPath.row].bettingData.overUnder) + "\n" + String("-110"), for: .normal)
        cell.totalHome.titleLabel?.textAlignment = .center

    
        return cell
    }
}

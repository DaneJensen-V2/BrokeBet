//
//  BetClickedViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/21/21.
//

import UIKit
import BottomHalfModal
import Lottie
import Firebase
var teamBetOn = ""
var awayTeamAbbrv = ""
var homeTeamAbbrv = ""
var creatingParlay = false
var currentParlay = [UserBet]()
var parlayComponents = [parlayComponent]()
var firstClick = true
class BetClickedViewController: UIViewController, SheetContentHeightModifiable {
    var titleText = ""
    var teamNameText = ""
    var spread = ""
    var betType = ""
    var odds = ""
    let db = DBManager()

    
    let firestoreDB = Firestore.firestore()

    
    @IBOutlet weak var spreadOverText: UILabel!
    @IBOutlet weak var oddsLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var calculatedAmount: UILabel!
    
    @IBOutlet weak var clickedAnimation: LottieAnimationView!
    @IBOutlet weak var TopAnimation: LottieAnimationView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var typeOfBetLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var parlayButton: UIButton!
    var sheetContentHeightToModify: CGFloat = 800
    var buttonPressed = false

    override func viewDidLoad() {
        parlayButton.layer.cornerRadius = 12
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 30
        placeBetButton.layer.cornerRadius = 12
        
        gameName.text = titleText
        teamName.text = teamNameText
        typeOfBetLabel.text = betType
        oddsLabel.text = spread
        spreadOverText.text = odds
        textField.isHidden = false
        textField.delegate = self
        TopAnimation.isHidden = false
        TopAnimation.contentMode = .scaleAspectFit
        TopAnimation.play(fromFrame: 0, toFrame: 50, loopMode: .playOnce, completion: nil)
        
        textField.addTarget(self, action: #selector(BetClickedViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    @IBAction func touchedOutside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        buttonRef!.backgroundColor = UIColor(named: "lightGreen")

    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            adjustFrameToSheetContentHeightIfNeeded()
        }
    @objc func textFieldDidChange(_ textField: UITextField) {
        var betAmountString = textField.text
        let stringSize = betAmountString?.count
     
        betAmountString = betAmountString?.substring(with: 1..<stringSize!).replacingOccurrences(of: ",", with: "")
        
       // if(oddsLabel.text)
        print(betAmountString)
        if let betAmountInt = Int(betAmountString!){
            print(self.spreadOverText.text!)
            print(betAmountInt)
            let potentialPayout = self.calculatePayout(betAmount: betAmountInt, spread: self.spreadOverText.text!)
            calculatedAmount.text = "PAYS: $" + String(potentialPayout)

        }
    }
    
    func calculatePayout(betAmount : Int, spread : String) -> Int{
        let betAmountDouble  = Double(betAmount)
        let spreadInt: Double? = Double(spread)
        if(spreadInt! > 0){
           
            let payout = betAmountDouble * (abs(spreadInt!) / 100.0)
            return Int(payout + betAmountDouble)
        }
        else if(spreadInt! < 0){
            let payout = betAmountDouble / (abs(spreadInt!) / 100.0)
            return Int(payout + betAmountDouble)
        }
        else{
            return 0

        }
    }
    func wagerChanged(){
        if !textField.text!.hasNumbers{
            calculatedAmount.text = "PAYS: $0"
        }
        if textField.text?.count ?? 0 > 1{
            placeBetButton.isEnabled = true
            placeBetButton.alpha = 1
        
        var betAmountString = textField.text
        let stringSize = betAmountString?.count
     
        betAmountString = betAmountString?.substring(with: 1..<stringSize!).replacingOccurrences(of: ",", with: "")
        
       // if(oddsLabel.text)
        if let betAmountInt = Int(betAmountString!){
            print(betAmountInt)
            let potentialPayout = self.calculatePayout(betAmount: betAmountInt, spread: self.spreadOverText.text!)
            calculatedAmount.text = "PAYS: " + String(potentialPayout).currency

        }
   
    }
    
   
    }
    @IBAction func createParlayClicked(_ sender: UIButton) {
        creatingParlay = true
        self.dismiss(animated: true, completion: nil)
    
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let game = activeGames[buttonIndex[2]][buttonIndex[0]]
        let newParlay = parlayComponent(teamID: teamIDClicked, typeOfBet: self.typeOfBetLabel.text!, odds: self.spreadOverText.text!, betGameID: game.gameID, spread: self.oddsLabel.text!, outcome: "Open", homeAbbrv: homeTeamAbbrv, longHomeName: game.homeTeamLong, longAwayName: game.awayTeamLong, date: game.datePrint, awayAbbrv: awayTeamAbbrv, teamBetOn: self.teamNameText, league: game.league, buttonIndex: buttonIndex)
        
        parlayComponents.append(newParlay)
        print(buttonIndex)
        tableData[buttonIndex[2]][buttonIndex[0]].selectedButtons[buttonIndex[1]] = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "parlay"), object: nil)
        firstClick = false

    }
    @IBAction func placeBetPushed(_ sender: UIButton) {
        
        
        var betAmountString = textField.text
        let stringSize = betAmountString?.count
        betAmountString = betAmountString?.substring(with: 1..<stringSize!).replacingOccurrences(of: ",", with: "")
        
        if let betAmountInt = Int(betAmountString!){
        
        print(betAmountInt)
            
            if(betAmountInt <= 0){
                let alert = UIAlertController(title: "Error Placing Bet", message: "Amount must be greater than 0", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
            else if(betAmountInt > currentUser.currentBalance){
                let alert = UIAlertController(title: "Error Placing Bet", message: "Amount must be less than your current balance", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
            else{
                buttonPressed = true
                print(textField.text!)
                gameName.isHidden = true
                teamName.isHidden = true
                spreadOverText.isHidden = true
                placeBetButton.isHidden = true
                oddsLabel.isHidden = true
                typeOfBetLabel.isHidden = true
                TopAnimation.isHidden = true
                textField.isHidden = true
                clickedAnimation.isHidden = false
                calculatedAmount.isHidden = true
                parlayButton.isHidden = true
                clickedAnimation.contentMode = .scaleAspectFill
                clickedAnimation.loopMode = .playOnce
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                clickedAnimation.play { Bool in
                    buttonRef!.backgroundColor = UIColor(named: "lightGreen")
                    self.dismiss(animated: true, completion: nil)
                    currentUser.currentBalance = currentUser.currentBalance - betAmountInt
                    let user = Auth.auth().currentUser

                    let currentuserID = user?.uid
                    let currentUserDB = self.firestoreDB.collection("Users").document(currentuserID!)

                   
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let currentDate = formatter.string(from: date)
                    
                    
                    let potentialPayout = self.calculatePayout(betAmount: betAmountInt, spread: self.spreadOverText.text!)

                    let newBet = UserBet(identifier: UUID().uuidString, amountBet: betAmountInt, potentialPayout: potentialPayout, outcome: "Open", betPlaced: currentDate, odds: self.spreadOverText.text!, spread: self.oddsLabel.text!, teamID: teamIDClicked, typeOfBet: self.typeOfBetLabel.text!, betGameID: currentGame!.gameID, homeAbbrv: homeTeamAbbrv, awayAbbrv: awayTeamAbbrv, league: currentGame!.league, teamBetOn: self.teamNameText, isParlay: false, parlayComponents: [])
                    
                    self.db.addBet(bet: newBet)
           
                   
                }
            }
        }
        
        
        

        
     }
     
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
extension BetClickedViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let finalString = text.replacingCharacters(in: range, with: string)

        // 'currency' is a String extension that doews all the number styling
        self.textField.text = finalString.currency
        wagerChanged()
        // returning 'false' so that textfield will not be updated here, instead from styling extension

        return false
    }
}

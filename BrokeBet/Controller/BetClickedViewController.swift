//
//  BetClickedViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/21/21.
//

import UIKit
import BottomHalfModal
import CurrencyTextField
import Lottie
import Firebase

class BetClickedViewController: UIViewController, SheetContentHeightModifiable {
    var titleText = ""
    var teamNameText = ""
    var spread = ""
    var betType = ""
    var odds = ""
    let db = Firestore.firestore()

    
    @IBOutlet weak var spreadOverText: UILabel!
    @IBOutlet weak var oddsLabel: UILabel!
    @IBOutlet weak var textField: CurrencyTextField!
    @IBOutlet weak var calculatedAmount: UILabel!
    
    @IBOutlet weak var clickedAnimation: AnimationView!
    @IBOutlet weak var TopAnimation: AnimationView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var typeOfBetLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var sheetContentHeightToModify: CGFloat = 800
    var buttonPressed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 30
        placeBetButton.layer.cornerRadius = 12
        
        gameName.text = titleText
        teamName.text = teamNameText
        typeOfBetLabel.text = betType
        oddsLabel.text = spread
        spreadOverText.text = odds
        textField.isHidden = false
        
        TopAnimation.isHidden = false
        TopAnimation.contentMode = .scaleAspectFit
        TopAnimation.play(fromFrame: 0, toFrame: 50, loopMode: .playOnce, completion: nil)
        
        textField.addTarget(self, action: #selector(BetClickedViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    @IBAction func touchedOutside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
                clickedAnimation.contentMode = .scaleAspectFill
                clickedAnimation.loopMode = .playOnce
                clickedAnimation.play { Bool in
                    self.dismiss(animated: true, completion: nil)
                    currentUser.currentBalance = currentUser.currentBalance - betAmountInt
                    let user = Auth.auth().currentUser

                    let currentuserID = user?.uid
                    let currentUserDB = self.db.collection("Users").document(currentuserID!)

                   
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let currentDate = formatter.string(from: date)
                    
                    
                    let potentialPayout = self.calculatePayout(betAmount: betAmountInt, spread: self.spreadOverText.text!)

                    let newBet : UserBet = UserBet(amountBet: betAmountInt, potentialPayout: potentialPayout, teamID: teamIDClicked, typeOfBet: self.typeOfBetLabel.text!, odds: self.spreadOverText.text!, betPlaced: currentDate, weekPlaced: currentWeek, betGameID: gameIDclicked, spread: self.oddsLabel.text!, outcome: "In Progress")
                    
                    let encoded: [String: Any]
                            do {
                                // encode the swift struct instance into a dictionary
                                // using the Firestore encoder
                                encoded = try Firestore.Encoder().encode(newBet)
                            } catch {
                                // encoding error
                                print(error)
                                return
                            }
                    
                    currentUser.activeBets.append(newBet)
                    // Set the "capital" field of the city 'DC'
                    currentUserDB.updateData([
                        "currentBalance": currentUser.currentBalance,
                        "Active Bets" : FieldValue.arrayUnion([encoded])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                   
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

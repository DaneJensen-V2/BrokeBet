//
//  ParlayViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 9/2/22.
//

import UIKit
import CurrencyText
import Lottie
import Firebase
import FirebaseAuth 
class ParlayViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var toWinBox: UITextField!
    @IBOutlet weak var wagerBox: UITextField!
    @IBOutlet weak var totalOddsLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var parlayTable: UITableView!
    @IBOutlet weak var balText: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var picksLabel: UILabel!
    @IBOutlet weak var animation: LottieAnimationView!
    @IBOutlet weak var balLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var picksView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var editingTable = false
    var doneEditing = false
    var tempParlays : [parlayComponent] = []

    let db = DBManager()
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteParlay), name: NSNotification.Name(rawValue: "deleteParlay"), object: nil)
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        balLabel.text = "$" + String(currentUser.currentBalance)
        closeButton.layer.cornerRadius = 10
        editButton.layer.cornerRadius = 10
        bottomView.layer.cornerRadius = 15
        picksView.layer.cornerRadius = 20
        balText.layer.cornerRadius = 20
        balText.layer.masksToBounds = true
        parlayTable.delegate = self
        parlayTable.dataSource = self
        placeBetButton.layer.cornerRadius = 15
        if parlayComponents.count == 1{
            picksLabel.text = "Pick"
        }
        tempParlays = parlayComponents
        //wagerBox.addShadow(location: .top, color: .black, opacity: 0.2, radius: 3.0)
   //    toWinBox.addShadow(location: .top, color: .black, opacity: 0.2, radius: 3.0)
        updateOdds()
       parlayTable.register(UINib(nibName : "ParlayTableViewCell", bundle: nil) , forCellReuseIdentifier: "parlayCell")
        countLabel.text = String(parlayComponents.count)
        bottomView.addShadow(location: .top, color: .black, opacity: 0.3, radius: 2.0)
        // Do any additional setup after loading the view.
        wagerBox.delegate = self
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("reloadTable"), object: nil)

        
    }

    @IBAction func closeClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
  
    func updateUI(){
        if parlayComponents.count == 0{
            errorLabel.text = "No bets seleceted."
            errorLabel.isHidden = false
            countLabel.text = "0"
            self.placeBetButton.isEnabled = false
            self.placeBetButton.alpha = 0.5

        }
        else if parlayComponents.count == 1{
            errorLabel.text = "Select 2 or more bets."
            errorLabel.isHidden = false
            countLabel.text = "1"
            self.placeBetButton.isEnabled = false
            self.placeBetButton.alpha = 0.5

        }
        else{
            determineCompatibleBets(){success in
                if success{
                    self.errorLabel.isHidden = true
                    self.placeBetButton.isEnabled = true
                    self.placeBetButton.alpha = 1


                }
                else{
                    self.errorLabel.text = "Some bets are incompatible."
                    self.placeBetButton.isEnabled = false
                    self.placeBetButton.alpha = 0.5
                    self.errorLabel.isHidden = false
                }
            }
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("test")
    }
    func determineCompatibleBets(completion: @escaping (Bool) -> Void){
        let invalidIndexes = [0,1,3,4]
        var list : [[Int]] = []
        if parlayComponents.count == 1{
            completion(true)
            return
        }
      
        var buttonIndexes : [[Int]] = []
        

        for bet in parlayComponents{
            buttonIndexes.append(bet.buttonIndex)

        }
        print(buttonIndexes)
        let sortedArray = buttonIndexes.sorted(by: {$0[0] < $1[0] })
        print(sortedArray)

       
        if parlayComponents.count == 2{
            if sortedArray[0][0] == sortedArray[1][0]{
                if invalidIndexes.contains(sortedArray[0][1])  && invalidIndexes.contains(sortedArray[1][1]){
                    completion(false)
                    return
                }
            }
            completion(true)
            return
        }
        else{
            var currentGame = sortedArray[0][0]
            var currentList : [Int] = []
            for x in 0...sortedArray.count - 1{
                if currentGame == sortedArray[x][0]{
                    currentList.append(sortedArray[x][1])
                    if x == sortedArray.count - 1{
                        list.append(currentList)
                    }
                }
            else if currentGame != sortedArray[x][0]{
                    currentGame = sortedArray[x][0]
                    list.append(currentList)
                    currentList = [sortedArray[x][1]]
                if x == sortedArray.count - 1{
                    list.append(currentList)
                }
                }
              
            }
            print(list)
            var found = false
            for positions in list{
                for index in positions{
                    if invalidIndexes.contains(index){
                        if found{
                            completion(false)
                            return
                        }
                        else{
                        found = true
                        }
                    }
                }
                found = false
            }
            completion(true)
            return
        }
            
        }
    
    @objc func deleteParlay(){
        
        print(cellToDelete)
        let cellClicked = tempParlays[cellToDelete]
        var count = 0
        for parlay in parlayComponents{
            if parlay.betGameID == cellClicked.betGameID && cellClicked.typeOfBet == parlay.typeOfBet && cellClicked.teamID == parlay.teamID{
                print("DELETED")
                parlayComponents.remove(at: count)
                tableData[cellClicked.buttonIndex[2]][cellClicked.buttonIndex[0]].selectedButtons[cellClicked.buttonIndex[1]] = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "parlay"), object: nil)
                break
            }
            count += 1
        }
        print("Deleting")
        let cellToDelete = IndexPath(row: count, section: 0)

        let indexes = [cellToDelete]
        DispatchQueue.main.async {
            self.parlayTable.deleteRows(at: indexes, with: UITableView.RowAnimation.right)

        }
        countLabel.text = String(parlayComponents.count)
        updateOdds()
        wagerChanged()
        updateUI()
    }
    func updateOdds(){
       
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

            self.totalOddsLabel.text = odds
        }
        
        
    }
   
    
    @IBAction func clearAllBets(_ sender: UIButton) {
        let alert = UIAlertController(title: "Clear Bets", message: "Are you sure you want to clear all bets in your betslip?", preferredStyle: UIAlertController.Style.alert)

               // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Clear", style: UIAlertAction.Style.destructive, handler: { action in

            self.updateOdds()
            self.uncheckAllButtons()
            self.parlayTable.reloadData()
            self.updateUI()

        }))
               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
   

               // show the alert
               self.present(alert, animated: true, completion: nil)
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
   
    @IBAction func placeBetPushed(_ sender: UIButton) {
        var betAmountString = wagerBox.text
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
                //buttonPressed = true
                currentUser.currentBalance = currentUser.currentBalance - betAmountInt
            
               
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let currentDate = formatter.string(from: date)
                
                
                let potentialPayout = calculatePayout(betAmount: betAmountInt, spread: totalOddsLabel.text!)
               
                
             //   let newBet = UserBet(identifier: UUID().uuidString, isParlay: true, amountBet: betAmountInt, potentialPayout: potentialPayout, outcome: "Open", betPlaced: currentDate, odds: self.totalOddsLabel.text!, teamID: teamIDClicked, typeOfBet: "Parlay", betGameID: gameIDclicked, spread: "Parlay", league: "", homeAbbrv: homeTeamAbbrv, awayAbbrv: awayTeamAbbrv, teamBetOn: String(parlayComponents.count) + " Teams", parlayComponents: parlayComponents)
                
                let newBet = UserBet(identifier: UUID().uuidString, amountBet: betAmountInt, potentialPayout: potentialPayout, outcome: "Open", betPlaced: currentDate, odds: self.totalOddsLabel.text!, spread: "Parlay", teamID: teamIDClicked, typeOfBet: "Parlay", betGameID: currentGame!.gameID, homeAbbrv: homeTeamAbbrv, awayAbbrv: awayTeamAbbrv, league: currentGame!.league, teamBetOn: String(parlayComponents.count) + " Teams", isParlay: true, parlayComponents: parlayComponents)
                
                db.addBet(bet: newBet)
               
                
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                
                animation.contentMode = .scaleAspectFill
                animation.loopMode = .playOnce
                parlayTable.isHidden = true
                bottomView.isHidden = true
                self.uncheckAllButtons()
                creatingParlay = false
                animation.play { Bool in
                    self.dismiss(animated: true, completion: nil)
                }
            
                   
                }
            }
        }
    func uncheckAllButtons(){
        for bet in parlayComponents{
            
            tableData[bet.buttonIndex[2]][bet.buttonIndex[0]].selectedButtons[bet.buttonIndex[1]] = false
           
        }
        parlayComponents = []
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "parlay"), object: nil)
    }
    func wagerChanged(){
        if !wagerBox.text!.hasNumbers{
            print("test")
            placeBetButton.isEnabled = false
            placeBetButton.alpha = 0.5
            toWinBox.text = "$0"
        }
        if wagerBox.text?.count ?? 0 > 1{
            placeBetButton.isEnabled = true
            placeBetButton.alpha = 1
        
        var betAmountString = wagerBox.text
        let stringSize = betAmountString?.count
     
        betAmountString = betAmountString?.substring(with: 1..<stringSize!).replacingOccurrences(of: ",", with: "")
        
       // if(oddsLabel.text)
        if let betAmountInt = Int(betAmountString!){
            print(betAmountInt)
            let potentialPayout = self.calculatePayout(betAmount: betAmountInt, spread: self.totalOddsLabel.text!)
            toWinBox.text = String(potentialPayout).currency

        }
   
    }
    
   
    }
    func calculatePayout(betAmount : Int, spread : String) -> Int{
        let betAmountDouble  = Double(betAmount)
        if let spreadInt = Double(spread){
            
        print(betAmount)
            print(spread)

        if(spreadInt > 0){
           
            let payout = betAmountDouble * (abs(spreadInt) / 100.0)
            return Int(payout + betAmountDouble)
        }
        else if(spreadInt < 0){
            let payout = betAmountDouble / (abs(spreadInt) / 100.0)
            return Int(payout + betAmountDouble)
        }
        else{
            return 0

        }
        }
        else{
            return 0
        }
    }
    @IBAction func editClicked(_ sender: UIButton) {
        if editingTable{
            editingTable = false
            doneEditing = true
            editButton.setTitle("Edit", for: .normal)
            editButton.titleLabel?.font =  UIFont(name: "FrancophilSans", size: 21)

            parlayTable.reloadData()

        }
        else{
            print("test")
            editButton.titleLabel?.font =  UIFont(name: "FrancophilSans", size: 17)
            editButton.setTitle("Done", for: .normal)
            editingTable = true
            parlayTable.reloadData()
        }
     
    }
}

extension UIView {
    enum VerticalLocation: String {
        case bottom
        case top
    }
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
extension ParlayViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return parlayComponents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = parlayTable.dequeueReusableCell(withIdentifier: "parlayCell", for : indexPath) as! ParlayTableViewCell
        let currentParlay = parlayComponents[indexPath.row]
        if currentParlay.teamID == "Home"{
            cell.teamLabel.text = currentParlay.homeAbbrv + " " + currentParlay.longHomeName

        }
        else{
            cell.teamLabel.text = currentParlay.awayAbbrv + " " + currentParlay.longAwayName

        }
        if currentParlay.typeOfBet == "Spread"{
            cell.spread.text = currentParlay.spread

        }
        else if currentParlay.typeOfBet == "Moneyline"{
            cell.spread.text = "ML"

        }else {
            cell.spread.text = currentParlay.spread

        }
        cell.oddsLabel.text = currentParlay.odds
        cell.spreadLabel.text = currentParlay.typeOfBet
        cell.dateLabel.text = currentParlay.date
        cell.matchupLabel.text = currentParlay.awayAbbrv + " " + currentParlay.longAwayName + " @ " + currentParlay.homeAbbrv + " " + currentParlay.longHomeName
        if editingTable{
            cell.showXButton()
        }
        else if doneEditing{
            cell.hideXButton()
           // doneEditing = false
        }
        cell.index = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension ParlayViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let finalString = text.replacingCharacters(in: range, with: string)

        // 'currency' is a String extension that doews all the number styling
        self.wagerBox.text = finalString.currency
        wagerChanged()
        // returning 'false' so that textfield will not be updated here, instead from styling extension

        return false
    }
}

extension String {
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")

        let styler = NumberFormatter()
        styler.minimumFractionDigits = 0
        styler.maximumFractionDigits = 0
        styler.maximumIntegerDigits = 6
        styler.currencySymbol = "$"
        styler.numberStyle = .currency

        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return styler.string(from: result)!
        }

        return self
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

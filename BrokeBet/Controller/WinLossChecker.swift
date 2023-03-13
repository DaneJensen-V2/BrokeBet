//
//  WinLossChecker.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/4/22.
//

import Foundation
struct outcomeChecker{
    /*
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
     */
}

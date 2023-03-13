//
//  DBManager.swift
//  BrokeBet
//
//  Created by Dane Jensen on 9/9/22.
//


import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class DBManager{
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func addBet(bet : UserBet){
        let user = auth.currentUser
        let currentuserID = user?.uid
        let currentUserDB = self.db.collection("Users").document(currentuserID!)
        currentUser.Bets += 1
        
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
        currentUser.activeBets.append(bet)
        currentUserDB.updateData([
            "currentBalance": currentUser.currentBalance,
            "Active Bets" : FieldValue.arrayUnion([encoded]),
            "Bets" : currentUser.Bets
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateStats"), object: nil)

            }
        }
    }
}

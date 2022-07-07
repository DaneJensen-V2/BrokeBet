//
//  UserInfo.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/10/21.
//

import Foundation
struct BBUser : Codable{
    let  UserID : String
    let firstName : String
    let lastName : String
    var currentBalance : Int
    var activeBets : [UserBet]
    var allBets : [UserBet]
    var Bets : Int
    var Won : Int
    var Lost : Int
    var Earned : Double


enum CodingKeys: String, CodingKey {
       case UserID
       case firstName
       case lastName
       case currentBalance
       case activeBets = "Active Bets"
       case allBets = "All Bets"
        case Bets
    case Won
    case Lost
    case Earned
   }

}

//
//  UserBet.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/10/21.
//

import Foundation
struct UserBet : Codable{
    var amountBet : Int
    var potentialPayout : Int
    var teamID : String
    var typeOfBet : String
    var odds : String
    var betPlaced : String
    var weekPlaced : Int
    var betGameID : String
    var spread : String
    var outcome : String
    
    enum CodingKeys: String, CodingKey {
           case amountBet
           case potentialPayout
           case teamID
           case typeOfBet
           case odds
           case betPlaced
            case weekPlaced
            case betGameID
            case spread
            case outcome
       }
}

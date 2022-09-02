//
//  UserBet.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/10/21.
//

import Foundation

struct UserBet : Codable{
    var identifier : String
    var isParlay : Bool
    var amountBet : Int
    var potentialPayout : Int
    var outcome : String
    var betPlaced : String
    var weekPlaced : Int
    var odds : String
    var teamID : String
    var typeOfBet : String
    var betGameID : String
    var spread : String
    var homeAbbrv : String
    var awayAbbrv : String
    var teamBetOn : String
    var parlayComponents : [parlayComponent]

    enum CodingKeys: String, CodingKey {
           case identifier
            case isParlay
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
            case homeAbbrv
            case awayAbbrv
            case teamBetOn
           case parlayComponents
       }
}

struct parlayComponent : Codable{
    
    var teamID : String
    var typeOfBet : String
    var odds : String
    var betGameID : String
    var spread : String
    var outcome : String
    var homeAbbrv : String
    var awayAbbrv : String
    var teamBetOn : String
    
    enum CodingKeys: String, CodingKey {

           case teamID
           case typeOfBet
           case odds
           case betGameID
           case spread
           case outcome
           case homeAbbrv
           case awayAbbrv
           case teamBetOn
       }
}

  
    
    
    
   

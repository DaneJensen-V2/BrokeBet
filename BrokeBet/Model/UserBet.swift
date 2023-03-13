//
//  UserBet.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/10/21.
//

import Foundation

struct UserBet : Codable{
    //unique ID to indentify the bet
    var identifier : String
    
    //amount the user spent on the bet and how much it pays if the bet wins
    var amountBet : Int
    var potentialPayout : Int
    
    //if the bet won or not, can be open, won, or lost
    var outcome : String
    
    //Date the bet was placed
    var betPlaced : String
    
    //odds of bet, ex: -110
    var odds : String
    //spread of bet if applicable, ex -110
    var spread : String
    
    //teamID is home or away
    var teamID : String
    //Spread, Moneyline, Over/Under
    var typeOfBet : String
    //ESPN gameID of game bet on
    var betGameID : String
    
    //Team abbreviation and string that corresponds to team image
    var homeAbbrv : String
    var awayAbbrv : String
    
    //League of the game ex MLB, NFL, NHL
    var league : String
    //Full name of team bet on
    var teamBetOn : String
    //If Bet is a parlay then it has an array of parlay objects
    var isParlay : Bool
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
           case betGameID
           case spread
           case outcome
           case homeAbbrv
           case awayAbbrv
           case teamBetOn

           case parlayComponents
           case league
       }
}


struct parlayComponent : Codable {
    var teamID : String
    var typeOfBet : String
    var odds : String
    var betGameID : String
    var spread : String
    var outcome : String
    var homeAbbrv : String
    var longHomeName : String
    var longAwayName : String
    var date : String
    var awayAbbrv : String
    var teamBetOn : String
    var league : String
    var buttonIndex = [0,0,0]
    
    enum CodingKeys: String, CodingKey {
           case teamID
           case typeOfBet
           case odds
           case betGameID
           case spread
           case longHomeName
           case longAwayName
           case date
           case outcome
           case homeAbbrv
           case awayAbbrv
           case teamBetOn
           case buttonIndex
           case league
       }
}

  

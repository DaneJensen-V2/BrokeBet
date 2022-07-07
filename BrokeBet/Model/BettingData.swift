//
//  BettingData.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/21/21.
//

import Foundation

struct BettingData : Decodable {
   let pickcenter : [pickcenter]
}
struct pickcenter : Decodable {
    
    let overUnder : Double
    let spread : Double
    let awayTeamOdds : awayTeamOdds
    let homeTeamOdds : homeTeamOdds

}

struct awayTeamOdds : Decodable{
    
    let favorite : Bool
    let moneyLine : Int
    let spreadOdds : Double
}
struct homeTeamOdds : Decodable{
    let favorite : Bool
    let moneyLine : Int
    let spreadOdds : Double
}



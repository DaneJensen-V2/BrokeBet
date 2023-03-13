//
//  MatchupData.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
import UIKit

struct MatchupData {
    let awayTeam : String
    let awayTeamLong : String
    let awayScore : String
    let awayLogo : UIImage?
    let awayColor : String
    let awayRecord : String

    
    
    let homeTeam : String
    let homeTeamLong : String
    let homeScore : String
    let homeLogo : UIImage?
    let homeColor : String
    let homeRecord : String

    
    
    let gameID : String
    let Quarter : Int
    let currentTime : String
    let date : String
    let datePrint : String
    let gameStatus : String
    let league : String
    
    var bettingData : BetData
    
}
struct betDataForTable{
    var title : String
    var date : String
    var homeTeamImage : UIImage
    var homeTeamColor : String
    var awayTeamImage : UIImage
    var awayTeamColor : String
    var awayTeamName : String
    var homeTeamName : String
    var spreadAway : String
    var moneyAway : String
    var totalAway : String
    var spreadHome : String
    var moneyHome : String
    var totalHome : String
    var league : String
    
    var selectedButtons = [false, false, false, false, false, false]
}

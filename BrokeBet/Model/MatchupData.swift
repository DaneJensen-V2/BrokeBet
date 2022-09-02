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
    var awayPassers : [PassingStats]
    var awayRushers : [RushingStats]
    var awayReceivers : [ReceivingStats]
    
    
    let homeTeam : String
    let homeTeamLong : String
    let homeScore : String
    let homeLogo : UIImage?
    let homeColor : String
    let homeRecord : String
    var homePassers : [PassingStats]
    var homeRushers : [RushingStats]
    var homeReceivers : [ReceivingStats]
    
    
    let gameID : String
    let Quarter : Int
    let currentTime : String
    let date : String
    let datePrint : String
    let gameStatus : String
    
    var bettingData : BetData
    var gameList : [MatchupData]
    
}
struct betDataForTable{
    var title : String
    var date : String
    var homeTeamImage : UIImage
    var awayTeamImage : UIImage
    var awayTeamName : String
    var homeTeamName : String
    var spreadAway : String
    var moneyAway : String
    var totalAway : String
    var spreadHome : String
    var moneyHome : String
    var totalHome : String
    
    var selectedButtons = [false, false, false, false, false, false]
}

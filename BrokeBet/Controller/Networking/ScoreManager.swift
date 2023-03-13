//
//  ScoreManager.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
import UIKit

var currentGameList = [[MatchupData]]()
var activeGames = [[MatchupData]]()
var currentWeek = 0
var totalGames = 0
struct scoreFetcher{
   
    enum ScoreFetcherError: Error {
           case invalidURL
           case missingData
       }
    
  
    func fetchGames(from url: String) async throws -> GameData{
        guard let url = URL(string: url) else {
            throw ScoreFetcherError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let gameResult = try JSONDecoder().decode(GameData.self, from: data)
    
        return gameResult
    }
    
    func parseGameResults(game : String, data : GameData) async throws -> [MatchupData]{
        let totalEvents = data.events.count
        var list : [MatchupData] = []
        
        for eventNumber in 0...totalEvents - 1 {
            
        let awayTeam = data.events[eventNumber].competitions[0].competitors[1]
        let homeTeam = data.events[eventNumber].competitions[0].competitors[0]
        let event = data.events[eventNumber].competitions[0]
            
        let awayTeamAbbrv = awayTeam.team.abbreviation
        let awayTeamLong = awayTeam.team.shortDisplayName
        let awayScore = awayTeam.score
        let awayColor = awayTeam.team.color
        let awayRecord = awayTeam.records[0].summary
        let awayImage = UIImage(named: game + "-" + awayTeamAbbrv)
            
        let homeTeamAbbrv = homeTeam.team.abbreviation
        let homeTeamLong = homeTeam.team.shortDisplayName
        let homeScore = homeTeam.score
        let homeRecord = homeTeam.records[0].summary
        let homeColor = homeTeam.team.color
        let homeImage = UIImage(named: game + "-" + homeTeamAbbrv)

        let clock = event.status.displayClock
        let quarter = event.status.period
       
        let gameID = data.events[eventNumber].id
        let gameStatus = event.status.type.state
            

            
         var date = event.date
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            dateFormatterGet.timeZone = NSTimeZone(name: "UTC" ) as TimeZone?
            
        var dateBetting = event.date
            let dateFormatterGet2 = DateFormatter()
            dateFormatterGet2.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            dateFormatterGet2.timeZone = NSTimeZone(name: "UTC" ) as TimeZone?
            
            let dateFormatterPrint2 = DateFormatter()
            dateFormatterPrint2.dateFormat = "ha '|' MMM d"
            dateFormatterPrint2.timeZone = NSTimeZone(name: "MST") as TimeZone?
            
            
            let datePrint2: Date = dateFormatterGet2.date(from: dateBetting)!
            
            dateBetting = dateFormatterPrint2.string(from: datePrint2)
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "E, MMM d h:mm a"
            dateFormatterPrint.timeZone = NSTimeZone(name: "MST") as TimeZone?
            
            let datePrint: Date = dateFormatterGet.date(from: date)!
            
            date = dateFormatterPrint.string(from: datePrint)
            
            let bet = BetData(homeSpread: 0, awaySpread: 0, spreadOddsAway: 0, overUnder: 0, spreadOddsHome: 0,  moneyLineHome: 0, moneyLineAway: 0)
            
            
            
            let game = MatchupData(awayTeam: awayTeamAbbrv, awayTeamLong: awayTeamLong, awayScore: awayScore, awayLogo: awayImage, awayColor : awayColor, awayRecord: awayRecord, homeTeam: homeTeamAbbrv, homeTeamLong: homeTeamLong, homeScore: homeScore, homeLogo: homeImage ?? UIImage(named: "football")!, homeColor : homeColor, homeRecord: homeRecord, gameID: gameID, Quarter: quarter, currentTime: clock, date: date, datePrint: dateBetting, gameStatus: gameStatus, league: "NFL", bettingData: bet)
            
            list.append(game)
        }
        return list
    }
    
  
}

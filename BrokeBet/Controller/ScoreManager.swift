//
//  ScoreManager.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
import UIKit

var currentGameList = [MatchupData]()
var activeGames = [MatchupData]()
var currentWeek = 0

var totalEvents = 13
struct footballMatch{
    
    var gameURL = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?dates=2020&seasontype=2&week=5"

    

func performRequest(urlString : String){
    
    
        if let url = URL(string: urlString){
        
        let session = URLSession(configuration: .default)
        
       let task =  session.dataTask(with: url, completionHandler: handle(data:response:error:))
        
        task.resume()
    }
    
}

func handle(data: Data?, response: URLResponse?, error:  Error?){
    
    if error != nil {
        print(error!)
        return
    }
    if let safeData = data {
        self.parseJSON(safeData: safeData)

    }
}
    func parseJSON(safeData : Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GameData.self, from: safeData)
            currentWeek = decodedData.week.number
            
            totalEvents = decodedData.events.count
            for index in 0...totalEvents-1 {

            let awayTeam = decodedData.events[index].competitions[0].competitors[1].team.abbreviation

            let awayTeamLong = decodedData.events[index].competitions[0].competitors[1].team.shortDisplayName
                
               
            let homeTeam = decodedData.events[index].competitions[0].competitors[0].team.abbreviation
                
            let homeTeamLong = decodedData.events[index].competitions[0].competitors[0].team.shortDisplayName
                
            let clock = decodedData.events[index].competitions[0].status.displayClock
            let quarter = decodedData.events[index].competitions[0].status.period
            let awayScore = decodedData.events[index].competitions[0].competitors[1].score
            let homeScore = decodedData.events[index].competitions[0].competitors[0].score
            let gameID = decodedData.events[index].id
            let gameStatus = decodedData.events[index].competitions[0].status.type.state
                
            let homeRecord = decodedData.events[index].competitions[0].competitors[0].records[0].summary
                
            let awayRecord = decodedData.events[index].competitions[0].competitors[1].records[0].summary
                
             var date = decodedData.events[index].competitions[0].date
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
                dateFormatterGet.timeZone = NSTimeZone(name: "UTC" ) as TimeZone?
                
            var dateBetting = decodedData.events[index].competitions[0].date
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

            
            let homeColor = decodedData.events[index].competitions[0].competitors[0].team.color
            let awayColor = decodedData.events[index].competitions[0].competitors[1].team.color
                
            //let homeLogoString = decodedData.events[index].competitions[0].competitors[0].team.logo
          //  let awayLogoString = decodedData.events[index].competitions[0].competitors[1].team.logo
                
              
                
                let awayImage = UIImage(named: awayTeam)
                
                let homeImage = UIImage(named: homeTeam)
                
                let bet = BetData(homeSpread: 0, awaySpread: 0, spreadOddsAway: 0, overUnder: 0, spreadOddsHome: 0,  moneyLineHome: 0, moneyLineAway: 0)
                
                let game = MatchupData(awayTeam: awayTeam, awayTeamLong: awayTeamLong, awayScore: awayScore, awayLogo: awayImage, awayColor : awayColor, awayRecord: awayRecord, awayPassers: [], awayRushers: [], awayReceivers: [], homeTeam: homeTeam, homeTeamLong: homeTeamLong, homeScore: homeScore, homeLogo: homeImage!, homeColor : homeColor, homeRecord: homeRecord, homePassers: [], homeRushers: [], homeReceivers: [], gameID: gameID, Quarter: quarter, currentTime: clock, date: date, datePrint: dateBetting, gameStatus: gameStatus, bettingData: bet, gameList: currentGameList)
            
                currentGameList.append(game)

            }
        }
        catch{
        print(error)
        }
    }
}

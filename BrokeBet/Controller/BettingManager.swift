//
//  ScoreManager.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
import UIKit


struct Betting{
    
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
            var homeSpread : Double;
            var awaySpread : Double;
            
            
            
            let decodedData = try decoder.decode(BettingData.self, from: safeData)
           
            let overUnder = decodedData.pickcenter[0].overUnder
            let spread = decodedData.pickcenter[0].spread
            
            
            let isHomeFavored = decodedData.pickcenter[0].awayTeamOdds.favorite
            if(isHomeFavored == false){
                 homeSpread = spread
                 awaySpread = spread * -1
            }
            
            
            else{
                 homeSpread = spread
                 awaySpread = spread * -1
            }

            let homeMoneyLine = decodedData.pickcenter[0].homeTeamOdds.moneyLine
            let awayMoneyLine = decodedData.pickcenter[0].awayTeamOdds.moneyLine
            
            let awaySpreadOdds = decodedData.pickcenter[0].awayTeamOdds.spreadOdds
            let homeSpreadOdds = decodedData.pickcenter[0].homeTeamOdds.spreadOdds
                
            let bet = BetData(homeSpread: homeSpread, awaySpread: awaySpread, spreadOddsAway: awaySpreadOdds, overUnder: overUnder, spreadOddsHome: homeSpreadOdds, moneyLineHome: homeMoneyLine, moneyLineAway: awayMoneyLine)
            

            currentGameList[runNumber2].bettingData = bet
            runNumber2 += 1
            print("Run Number : ")
            print(runNumber2)
            print(awayMoneyLine)
            print(homeMoneyLine)

            requestDone = true

        }
        catch{
        print(error)
        }

    }
}

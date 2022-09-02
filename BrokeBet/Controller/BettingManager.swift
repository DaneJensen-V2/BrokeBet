//
//  ScoreManager.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
import UIKit


struct Betting{
    
    func performRequest(urlString : String, count : Int, completion: @escaping (Bool) -> Void){
    
    if let url = URL(string: urlString){
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            handle(data: data, response: response, error: error, count: count){success in
                print("Completion Ran")
                completion(true)
            }
        }
        
        task.resume()
    }
    
}

    func handle(data: Data?, response: URLResponse?, error:  Error?, count: Int, completion: @escaping (Bool) -> Void){
    
    if error != nil {
        print("UH OH")
        print(error!)
        completion(false)
        return
    }
    if let safeData = data {
        self.parseJSON(safeData: safeData, count: count){success in
            completion(true)
            
        }

    }
}
    func parseJSON(safeData : Data, count: Int, completion: @escaping (Bool) -> Void){
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
            print(awaySpread)

            let homeMoneyLine = decodedData.pickcenter[0].homeTeamOdds.moneyLine
            let awayMoneyLine = decodedData.pickcenter[0].awayTeamOdds.moneyLine
            
            let awaySpreadOdds = decodedData.pickcenter[0].awayTeamOdds.spreadOdds
            let homeSpreadOdds = decodedData.pickcenter[0].homeTeamOdds.spreadOdds
                
            let bet = BetData(homeSpread: homeSpread, awaySpread: awaySpread, spreadOddsAway: awaySpreadOdds, overUnder: overUnder, spreadOddsHome: homeSpreadOdds, moneyLineHome: homeMoneyLine, moneyLineAway: awayMoneyLine)
            

            currentGameList[count].bettingData = bet
            


        }
        catch{
            completion(false)
        print(error)
        }
        completion(true)

    }
}

//
//  ScoreManager.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
import UIKit


struct bettingFetcher{
    
    
    enum BettingFetcherError: Error {
           case invalidURL
           case missingData
       }
    
    func fetchBettingData(from url: String, ID : String) async throws -> BetData{
        let fullURL = url + ID
        guard let url = URL(string: fullURL) else {
            throw BettingFetcherError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let gameSummary = try JSONDecoder().decode(BettingData.self, from: data)
     
        let betData = try await parseSummaryResults(data: gameSummary)
        
        return betData
    }
    
    func parseSummaryResults(data : BettingData) async throws -> BetData{
        
            var homeSpread : Double;
            var awaySpread : Double;
        
            
        if data.pickcenter.isEmpty{
                print("NO PICKS")
                
                return BetData(homeSpread: 0, awaySpread: 0, spreadOddsAway: 0, overUnder: 0, spreadOddsHome: 0, moneyLineHome: 0, moneyLineAway: 0)
            }
            else{
            let pickcenter = data.pickcenter[0]

            let overUnder = pickcenter.overUnder
            let spread = pickcenter.spread
            
            
            let isHomeFavored = pickcenter.awayTeamOdds.favorite
            if(isHomeFavored == false){
                 homeSpread = spread
                 awaySpread = spread * -1
            }
            
            
            else{
                 homeSpread = spread
                 awaySpread = spread * -1
            }
            print(awaySpread)
            var homeMoney = 0
            var awayMoney = 0
            
            if let homeMoneyLine = pickcenter.homeTeamOdds.moneyLine{
                homeMoney = homeMoneyLine
            }
            if let awayMoneyLine = pickcenter.awayTeamOdds.moneyLine{
                awayMoney = awayMoneyLine
            }
                var awayspread = 0.0
                var homespread = 0.0

                if let awaySpreadOdds = pickcenter.awayTeamOdds.spreadOdds{
                    awayspread = awaySpreadOdds
                }
                else{
                    awayspread = -110
                }
                if  let homeSpreadOdds = pickcenter.homeTeamOdds.spreadOdds{
                    homespread = homeSpreadOdds
                }
                else{
                    homespread = -110
                }
           
                
            let bet = BetData(homeSpread: homeSpread, awaySpread: awaySpread, spreadOddsAway: awayspread, overUnder: overUnder, spreadOddsHome: homespread, moneyLineHome: homeMoney, moneyLineAway: awayMoney)
            
            return bet
                
            }
    
 
    }

}

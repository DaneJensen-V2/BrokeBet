//
//  statsMananger.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/13/21.
//

import Foundation
var passersList = [PassingStats]()
var rushingList = [PlayerStats]()
var recievingList = [PlayerStats]()
var playerList = [[PlayerStats]]()
var runNumber = 0

struct teamStats{
    var timer = Timer()


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
        //print("parseRun")
      //  print(runNumber)
        do {
            
            let decodedData = try decoder.decode(PlayerStats.self, from: safeData)
            
            
            for athletes in decodedData.boxscore.players[0].statistics[0].athletes{
            
            let passer = PassingStats(passerName: athletes.athlete.displayName, passAT: athletes.stats[0], yards: athletes.stats[1], TD: athletes.stats[3], INT: athletes.stats[4], sacks: athletes.stats[5])
                
                currentGameList[runNumber].awayPassers.append(passer)
            }
            
            for athletes in decodedData.boxscore.players[0].statistics[1].athletes{
            
                let rusher = RushingStats(rusherName: athletes.athlete.displayName , rushAT: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4])
                
                currentGameList[runNumber].awayRushers.append(rusher)
            }
            for athletes in decodedData.boxscore.players[0].statistics[2].athletes{
            
                let receiver = ReceivingStats(receiverName: athletes.athlete.displayName, receptions: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4], targets: athletes.stats[5])
                
                currentGameList[runNumber].awayReceivers.append(receiver)
            }
            for athletes in decodedData.boxscore.players[1].statistics[2].athletes{
            
                let receiver = ReceivingStats(receiverName: athletes.athlete.displayName, receptions: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4], targets: athletes.stats[5])
                
                currentGameList[runNumber].homeReceivers.append(receiver)
            }
            
            for athletes in decodedData.boxscore.players[1].statistics[1].athletes{
            
                let rusher = RushingStats(rusherName: athletes.athlete.displayName , rushAT: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4])
                
                currentGameList[runNumber].homeRushers.append(rusher)
            }
            
            
            for athletes in decodedData.boxscore.players[1].statistics[0].athletes{
        
            let passer = PassingStats(passerName: athletes.athlete.displayName, passAT: athletes.stats[0], yards: athletes.stats[1], TD: athletes.stats[3], INT: athletes.stats[4], sacks: athletes.stats[5])
                
                currentGameList[runNumber].homePassers.append(passer)
            }
            runNumber += 1
            statsDone = true


            }
            

        catch{
        print(error)
            runNumber += 1
            statsDone = true

        }
      //  print(currentGameList[gameNum-1].awayPassers.count)
       
    }

}

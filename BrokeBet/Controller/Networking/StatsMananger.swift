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

struct teamStats{
    
    var timer = Timer()


    func performRequest(urlString : String, section: Int, count : Int, completion: @escaping (Bool) -> Void){
    print(urlString)
    if let url = URL(string: urlString){
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            handle(data: data, response: response, error: error, section: section, count: count){success in
                completion(true)
            }
        }
        
        task.resume()
    }
    
}

    func handle(data: Data?, response: URLResponse?, error:  Error?, section: Int, count: Int, completion: @escaping (Bool) -> Void){
    
    if error != nil {
        print(error!)
        completion(false)
        return
    }
    if let safeData = data {
        self.parseJSON(safeData: safeData, section: section, count: count){success in
            completion(true)
            
        }

    }
}
    func parseJSON(safeData : Data, section: Int, count : Int, completion: @escaping (Bool) -> Void){
        /*
        let decoder = JSONDecoder()
 
        do {
            
            let decodedData = try decoder.decode(PlayerStats.self, from: safeData)
            
            if decodedData.boxscore.players[0].statistics.count > 0 {
                
                for athletes in decodedData.boxscore.players[0].statistics[0].athletes{
                    
                    let passer = PassingStats(passerName: athletes.athlete.displayName, passAT: athletes.stats[0], yards: athletes.stats[1], TD: athletes.stats[3], INT: athletes.stats[4], sacks: athletes.stats[5])
                    
                    currentGameList[section][count].awayPassers.append(passer)
                }
                
                for athletes in decodedData.boxscore.players[0].statistics[1].athletes{
                    
                    let rusher = RushingStats(rusherName: athletes.athlete.displayName , rushAT: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4])
                    
                    currentGameList[[section]count].awayRushers.append(rusher)
                }
                for athletes in decodedData.boxscore.players[0].statistics[2].athletes{
                    
                    let receiver = ReceivingStats(receiverName: athletes.athlete.displayName, receptions: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4], targets: athletes.stats[5])
                    
                    currentGameList[section][count].awayReceivers.append(receiver)
                }
                for athletes in decodedData.boxscore.players[1].statistics[2].athletes{
                    
                    let receiver = ReceivingStats(receiverName: athletes.athlete.displayName, receptions: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4], targets: athletes.stats[5])
                    
                    currentGameList[section][count].homeReceivers.append(receiver)
                }
                
                for athletes in decodedData.boxscore.players[1].statistics[1].athletes{
                    
                    let rusher = RushingStats(rusherName: athletes.athlete.displayName , rushAT: athletes.stats[0], yards: athletes.stats[1], AVG: athletes.stats[2], TD: athletes.stats[3], Long: athletes.stats[4])
                    
                    currentGameList[section][count].homeRushers.append(rusher)
                }
                
                
                for athletes in decodedData.boxscore.players[1].statistics[0].athletes{
                    
                    let passer = PassingStats(passerName: athletes.athlete.displayName, passAT: athletes.stats[0], yards: athletes.stats[1], TD: athletes.stats[3], INT: athletes.stats[4], sacks: athletes.stats[5])
                    
                    currentGameList[section][count].homePassers.append(passer)
                }
            }
            completion(true)
            }
            

        catch{
        print(error)
            completion(false)

        }
       */
        completion(true)
    }

}

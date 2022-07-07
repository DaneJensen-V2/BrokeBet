//
//  PlayerStats.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/13/21.
//

import Foundation

struct PlayerStats : Decodable {
    
    let boxscore : boxscore
}

struct boxscore : Decodable{
    
    let players : [players]
}

struct players : Decodable{
    let statistics : [statistics]
}


struct statistics : Decodable {
    let athletes : [athletes]

}
struct athletes: Decodable{
    let athlete : athlete
    let stats : [String]
}
struct athlete : Decodable {
    let displayName : String
    
}



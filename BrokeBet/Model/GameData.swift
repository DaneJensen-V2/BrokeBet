//
//  GameData.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/11/21.
//

import Foundation
struct GameData : Decodable {
    
    let events : [events]
}

struct week : Decodable{
    
    let number : Int
}

struct events : Decodable{
    let competitions : [competitions]
    let id : String
}

struct competitions : Decodable {
    let competitors : [competitors]
    let status : status
    let date : String
}
struct status : Decodable {
    let displayClock : String
    let period : Int
    let type : type
}
struct type : Decodable{
    let state : String
}
struct competitors : Decodable {
    let team : team
    let score : String
    let records : [records]

}
struct records : Decodable {
    let summary : String
}
struct team : Decodable {
    let abbreviation : String
    let color : String
//    let name : String
    let shortDisplayName : String
}

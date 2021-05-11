//
//  Bp.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/20.
//

import Foundation

struct Bp: Codable {
    let lowBp: String
    let highBp: String
    let date: String
    let pulse: String
}

struct DeleteBp: Codable {
    let id: Int
    let lowBp: String
    let highBp: String
    let date: String
    let pulse: String
}

struct AllBp: Codable {
    let data: [DeleteBp]
}

struct OnlyHighBp: Codable {
    let data: [HighBp]
}

struct OnlyLowBp: Codable {
    let data: [LowBp]
}

struct HighBp: Codable{
    let highBp: String
    let date: String
}

struct LowBp: Codable {
    let lowBp: String
    let date: String
}

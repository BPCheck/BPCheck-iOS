//
//  Home.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/20.
//

import Foundation

struct Hospital: Codable {
    let hospitalName: String
}

struct Bp: Codable {
    let lowBp: String
    let highBp: String
    let date: String
    let pulse: String
}

struct Main: Codable {
    let userId: String
    let password: String
    let name: String
    let hospitals: Hospital
    let bps: [Bp]
}

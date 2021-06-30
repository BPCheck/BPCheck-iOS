//
//  Home.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/20.
//

import Foundation

struct Home: Codable {
    let userId: String
    let password: String
    let name: String
    let hospitals: [Hospital]
    let bps: [Bp]
}

struct Main: Codable {
    let main: Home?
}

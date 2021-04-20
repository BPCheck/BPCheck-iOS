//
//  Hospital.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/20.
//

import Foundation

struct HospitalRegister: Codable {
    let hospitalName: String
    let hospitalNumber: String
}

struct Hospital: Codable {
    let hospitalName: String
}

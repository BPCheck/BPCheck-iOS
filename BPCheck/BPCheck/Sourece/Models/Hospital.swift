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

struct HospitalInfomation: Codable {
    let hospitalName: String
    let hospitalNumber: String
    let isSelect: Bool
    let id: Int
}

struct HospitalInfo: Codable {
    let data: [HospitalInfomation]
}

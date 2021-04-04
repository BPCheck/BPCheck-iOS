//
//  BPCheckAPI.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/02.
//

import Foundation
import Moya

enum BPCheckAPI {
    case signUp(_ userId: String, _ password: String, _ name: String)
    case signIn(_ userId: String, _ password: String)
    case postBp(_ highBp: String, _ lowBp: String, _ pulse: String, _ date: String)
    case deleteBp(_ id: String)
    case postHospital(_ hospitalName: String, _ hospitalNumber: String)
    case deleteHospital(_ id: String)
    case selectHospital(_ id: String)
    case deselectHospital(_ id: String)
    case getBpLow
    case getBpHigh
    case getBpAll
    case getMain
}

extension BPCheckAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:3000")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/user/signUp"
        case .signIn:
            return "/user/signIn"
        case .postBp:
            return "/bp/check"
        case .deleteBp(let id):
            return "/bp/\(id)"
        case .postHospital:
            return "/hospital/register"
        case .deleteHospital(let id):
            return "/hospital/\(id)"
        case .selectHospital(let id):
            return "/hospital/select/\(id)"
        case .deselectHospital(let id):
            return "/hospital/deselect/\(id)"
        case .getBpLow:
            return "/bp/low"
        case .getBpHigh:
            return "/bp/high"
        case .getBpAll:
            return "/bp/all"
        case .getMain:
            return "/bp/main"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .signIn, .postBp, .postHospital:
            return .post
        case .deleteBp, .deleteHospital:
            return .delete
        case .selectHospital, .deselectHospital:
            return .put
        case .getMain, .getBpAll, .getBpHigh, .getBpLow:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .signIn(let userId, let password):
            return .requestParameters(parameters: ["userId": userId, "password": password], encoding: JSONEncoding.prettyPrinted)
        case .signUp(let userId, let password, let name):
            return .requestParameters(parameters: ["userId": userId, "password": password, "name": name], encoding: JSONEncoding.prettyPrinted)
        case .postBp(let highBp, let lowBp, let pulse, let date):
            return .requestParameters(parameters: ["highBp": highBp, "lowBp": lowBp, "pulse": pulse, "date": date], encoding: JSONEncoding.prettyPrinted)
        case .postHospital(let name, let number):
            return .requestParameters(parameters: ["hospitalName": name, "hospitalNumber": number], encoding: JSONEncoding.prettyPrinted)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
}

//guard let token = UserDefaults.standard.string(forKey: "token") else { return nil }
//print(token)
//return ["Authorization" : "Bearer " + token]

enum StatusRules: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case serverError = 500
    case fail = 0
}

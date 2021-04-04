//
//  Service.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/02.
//

import Foundation
import RxSwift
import Moya

class Service {
    let provider = MoyaProvider<BPCheckAPI>()

    func signIn(_ userId: String,_ password: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.signIn(userId, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Token.self)
            .map { token -> (StatusRules) in
                print(token.accessToken)
                UserDefaults.standard.set(token.accessToken, forKey: "token")
                UserDefaults.standard.synchronize()
                return .ok
            }.catchError { [unowned self] in return .just(setNetworkError($0)) }
    }
    
    func signUp(_ userId: String, name: String, password: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.signUp(userId, password, name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func setNetworkError(_ error: Error) -> StatusRules {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fail) }
        return (StatusRules(rawValue: status) ?? .fail)
    }
}

//
//  Service.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/02.
//

import Foundation
import RxSwift
import Moya

class Service: ServiceBasic {
    
    let provider = MoyaProvider<BPCheckAPI>()

    func signIn(_ userId: String,_ password: String) -> ReturnState {
        return provider.rx.request(.signIn(userId, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Token.self)
            .map { token -> (StatusRules) in
                UserDefaults.standard.set(token.accessToken, forKey: "token")
                UserDefaults.standard.synchronize()
                return .ok
            }.catchError { return .just(self.setNetworkError($0)) }
    }
    
    func signUp(_ userId: String, _ name: String, _ password: String) -> ReturnState {
        return provider.rx.request(.signUp(userId, password, name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func postMeasureBp(_ highBp: String, _ lowBp: String, _ pulse: String, _ date: String) -> ReturnState {
        return provider.rx.request(.postBp(highBp, lowBp, pulse, date))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func deleteBp(_ ID: String) -> ReturnState {
        return provider.rx.request(.deleteBp(ID))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func postRegisterHospital(_ hospitalName: String, _ hospitalNumber: String) -> ReturnState {
        return provider.rx.request(.postHospital(hospitalName, hospitalNumber))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func deleteHospital(_ ID: String) -> ReturnState {
        return provider.rx.request(.deleteHospital(ID))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func selectFavoritHospital(_ ID: String) -> ReturnState {
        return provider.rx.request(.selectHospital(ID))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func deselectFavoritHospital(_ ID: String) -> ReturnState {
        return provider.rx.request(.deselectHospital(ID))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
        
    func getMainFeed() -> ReturnStateWithData<Main> {
        return provider.rx.request(.getMain)
            .filterSuccessfulStatusCodes()
            .map(Main.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func getOnlyLowBp() -> ReturnStateWithData<OnlyLowBp> {
        return provider.rx.request(.getBpLow)
            .filterSuccessfulStatusCodes()
            .map(OnlyLowBp.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func getOnlyHighBp() -> ReturnStateWithData<OnlyHighBp> {
        return provider.rx.request(.getBpHigh)
            .filterSuccessfulStatusCodes()
            .map(OnlyHighBp.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func getAllBp() -> ReturnStateWithData<AllBp> {
        return provider.rx.request(.getBpAll)
            .filterSuccessfulStatusCodes()
            .map(AllBp.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func setNetworkError(_ error: Error) -> StatusRules {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fail) }
        return (StatusRules(rawValue: status) ?? .fail)
    }
}

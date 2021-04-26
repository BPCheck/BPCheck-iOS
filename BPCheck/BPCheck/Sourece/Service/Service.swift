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
            .retry(3)
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
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func postMeasureBp(_ highBp: String, _ lowBp: String, _ pulse: String, _ date: String) -> ReturnState {
        return provider.rx.request(.postBp(highBp, lowBp, pulse, date))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func deleteBp(_ id: String) -> ReturnState {
        return provider.rx.request(.deleteBp(id))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func postRegisterHospital(_ hospitalName: String, _ hospitalNumber: String) -> ReturnState {
        return provider.rx.request(.postHospital(hospitalName, hospitalNumber))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func deleteHospital(_ id: String) -> ReturnState {
        return provider.rx.request(.deleteHospital(id))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func selectFavoritHospital(_ id: String) -> ReturnState {
        return provider.rx.request(.selectHospital(id))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
    
    func deselectFavoritHospital(_ id: String) -> ReturnState {
        return provider.rx.request(.deselectHospital(id))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { return .just(self.setNetworkError($0))}
    }
        
    func getMainFeed() -> ReturnStateWithData<Main> {
        return provider.rx.request(.getMain)
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map(Main.self)
            .map{ return ($0, .ok) }
            .catchError { error in
                print(error)
                return .error(error) }
    }
    
    func getOnlyLowBp() -> ReturnStateWithData<OnlyLowBp> {
        return provider.rx.request(.getBpLow)
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map(OnlyLowBp.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func getOnlyHighBp() -> ReturnStateWithData<OnlyHighBp> {
        return provider.rx.request(.getBpHigh)
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map(OnlyHighBp.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func getAllBp() -> ReturnStateWithData<AllBp> {
        return provider.rx.request(.getBpAll)
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map(AllBp.self)
            .map{ return ($0, .ok) }
            .catchError { error in return .error(error) }
    }
    
    func getHospital() -> ReturnStateWithData<HospitalInfo> {
        return provider.rx.request(.getHospital)
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map (HospitalInfo.self)
            .map { return ($0, .ok)}
            .catchError { error in return .error(error)}
    }
    
    func setNetworkError(_ error: Error) -> StatusRules {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fail) }
        return (StatusRules(rawValue: status) ?? .fail)
    }
}

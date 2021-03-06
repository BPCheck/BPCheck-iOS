//
//  HospitalReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/26.
//

import Foundation
import ReactorKit
import RxFlow
import RxCocoa

final class HospitalReactor: Reactor, Stepper {
    enum Action {
        case refresh(Bool)
        case didSelectHospital(IndexPath)
        case postFavoritHospital(HospitalRegister)
        case deleteFavoritHospital(IndexPath)
    }
    
    enum Mutation {
        case setHosiptal(HospitalInfo)
        case setError(String)
        case setReload
    }
    
    struct State {
        var hospital: [HospitalInfomation]
        var result: String?
        var reloadData: Void?
    }
    
    let initialState: State
    private let service = Service()
    var steps: PublishRelay<Step> = .init()

    init() {
        initialState = State(hospital: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return service.getHospital().asObservable()
                .map { hospital, response in
                    print(response)
                    switch response {
                    case .ok:
                        return .setHosiptal(hospital)
                    case .conflict:
                        return .setError("conflict")
                    default:
                        return .setError("server error")
                    }
                }
        case .didSelectHospital(let indexPath):
            if !self.currentState.hospital[indexPath.row].isSelect {
                return service.selectFavoritHospital(String(self.currentState.hospital[indexPath.row].id)).asObservable()
                    .map { response in
                        switch response {
                        case .ok:
                            return .setReload
                        default:
                            return .setError("server error")
                        }
                    }
            }else {
                return service.deselectFavoritHospital(String(self.currentState.hospital[indexPath.row].id)).asObservable()
                    .map { response in
                        switch response {
                        case .ok:
                            return .setReload
                        default:
                            return .setError("server error")
                        }
                    }
            }

        case .deleteFavoritHospital(let indexPath):
            return service.deleteHospital(String(self.currentState.hospital[indexPath.row].id)).asObservable()
                .map { response in
                    switch response {
                    case .ok:
                        return .setReload
                    default:
                        return .setError("server error")
                    }
                }
            
        case .postFavoritHospital(let hospital):
            return service.postRegisterHospital(hospital.hospitalName, hospital.hospitalNumber).asObservable()
                .map { response in
                    switch response {
                    case .ok:
                        return .setReload
                    default:
                        return .setError("이미 등록된 병원입니다.")
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setHosiptal(let data):
            newState.hospital = data.data
            newState.result = "text"
        case .setError(let error):
            newState.result = error
        case .setReload:
            newState.result = nil
        }
        return newState
    }
}

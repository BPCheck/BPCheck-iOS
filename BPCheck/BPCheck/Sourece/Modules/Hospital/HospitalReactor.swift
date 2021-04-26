//
//  HospitalReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/26.
//

import Foundation
import ReactorKit

final class HospitalReactor: Reactor {
    enum Action {
        case load
    }
    
    enum Mutation {
        case setHosiptal(HospitalInfo)
        case setError(String)
    }
    
    struct State {
        var hospital: HospitalInfo?
        var result: String?
    }
    
    let initialState: State
    private let service = Service()
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return service.getHospital().asObservable()
                .map { hospital, response in
                    switch response {
                    case .ok:
                        return .setHosiptal(hospital)
                    case .conflict:
                        return .setError("conflict")
                    default:
                        return .setError("server error")
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setHosiptal(let data):
            newState.hospital = data
            newState.result = nil
        case .setError(let error):
            newState.hospital = nil
            newState.result = error
        }
        return newState
    }
}

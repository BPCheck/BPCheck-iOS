//
//  HighReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/27.
//

import Foundation
import ReactorKit

final class HighReactor: Reactor {
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setLowData(OnlyHighBp)
        case setError(String)
    }
    
    struct State {
        var chart: [HighBp]
        var result: String?
    }
    
    let initialState: State
    private let service = Service()
    
    init() {
        initialState = State(chart: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return service.getOnlyHighBp().asObservable()
                .map { low, response in
                    switch response {
                    case .ok:
                        return .setLowData(low)
                    default:
                        return .setError("")
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLowData(let data):
            newState.chart = data.data
            newState.result = nil
        case .setError(let error):
            newState.chart = []
            newState.result = error
        }
        return newState
    }
}

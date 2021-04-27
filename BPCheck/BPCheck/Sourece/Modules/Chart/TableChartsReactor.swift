//
//  TableChartsReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/27.
//

import Foundation
import ReactorKit

final class TableChartsReactor: Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setAllData(AllBp)
        case setError(String)
    }
    
    struct State {
        var chart: [Bp]
        var result: String?
    }
    
    let initialState: State
    private let service = Service()
    
    init() {
        initialState = State(chart: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return service.getAllBp().asObservable()
                .map { all, response in
                    switch response {
                    case .ok:
                        return .setAllData(all)
                    default:
                        return .setError("")
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setAllData(let data):
            newState.chart = data.data
            newState.result = nil
        case .setError(let error):
            newState.chart = []
            newState.result = error
        }
        return newState
    }
}

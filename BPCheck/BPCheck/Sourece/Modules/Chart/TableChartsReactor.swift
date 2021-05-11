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
        case deleteEnroll(IndexPath)
    }
    
    enum Mutation {
        case setAllData(AllBp)
        case setError(String)
        case setReload
    }
    
    struct State {
        var chart: [DeleteBp]
        var result: String?
        var reloadData: Void?
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
        case .deleteEnroll(let indexPath):
            return service.deleteBp(String(self.currentState.chart[indexPath.row].id)).asObservable()
                .map { response in
                    switch response {
                    case .ok:
                        return .setReload
                    default:
                        return .setError("server error")
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setAllData(let data):
            newState.chart = data.data
            newState.result = ""
        case .setError(let error):
            newState.result = error
        case .setReload:
            newState.result = nil
        }
        return newState
    }
}

//
//  HighReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/27.
//

import Foundation
import ReactorKit
import RxFlow
import RxCocoa

final class HighReactor: Reactor, Stepper {
    
    enum Action {
        case refresh
        case popVC
        case allChart
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
    var steps: PublishRelay<Step> = .init()

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
        case .popVC:
            steps.accept(BPCheckStep.popViewController)
            return .empty()
        case .allChart:
            steps.accept(BPCheckStep.allChartIsRequired)
            return .empty()
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

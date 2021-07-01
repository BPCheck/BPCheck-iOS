//
//  HomeReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/20.
//

import Foundation
import ReactorKit
import RxSwift
import RxFlow
import RxCocoa

final class HomeReactor: Reactor, Stepper{    
    
    enum Action {
        case refresh(Bool)
        case lowChart
        case highChart
    }
    
    enum Mutation {
        case setMainFeed(Main)
        case setError(String)
    }
    
    struct State {
        var main: Main?
        var result: String?
    }
    
    let initialState: State
    private let service = Service()
    var steps: PublishRelay<Step> = .init()

    init() {
        initialState = State(main: nil, result: nil)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .lowChart:
            steps.accept(BPCheckStep.lowChartIsRequired)
            return .empty()
        case .highChart:
            steps.accept(BPCheckStep.highChartIsRequired)
            return .empty()
        case .refresh:
            return service.getMainFeed().asObservable()
                .map { main, response in
                    print(response)
                    print(main)
                switch response {
                case .ok:
                    return .setMainFeed(main)
                default:
                    return .setError("메인 피드를 불러 올 수 없음")
                }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMainFeed(let data):
            newState.main = data
            newState.result = nil
        case .setError(let error):
            newState.main = nil
            newState.result = error
        }
        return newState
    }
}

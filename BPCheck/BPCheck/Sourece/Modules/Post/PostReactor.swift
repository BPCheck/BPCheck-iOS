//
//  PostReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/27.
//

import Foundation
import ReactorKit
import RxCocoa

final class PostReactor: Reactor {
    enum Action {
        case postBp(Bp)
    }
    
    enum Mutation {
        case setPopVC(Bool)
        case setError(String)
    }
    
    struct State {
        var result: String?
        var isDismiss: Bool
    }
    
    let initialState: State
    private let service = Service()
    
    init() {
        initialState = State(isDismiss: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .postBp(let bp):
            return service.postMeasureBp(bp.highBp, bp.lowBp, bp.pulse, bp.date).asObservable()
                .map { response in
                    switch response {
                    case .ok:
                        return .setPopVC(true)
                    default:
                        return .setError("이미 해당 날짜에 작성한 이력이 있습니다")
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPopVC(let access):
            newState.isDismiss = access
        case .setError(let error):
            newState.result = error
            newState.isDismiss = false
        }
        return newState
    }
}

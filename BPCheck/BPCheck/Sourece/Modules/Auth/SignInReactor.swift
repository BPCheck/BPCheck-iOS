//
//  SignInReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/02.
//

import Foundation
import ReactorKit
import RxSwift
import RxFlow
import RxCocoa

final class SignInReactor: Reactor, Stepper {
    
    enum Action {
        case doneTap
        case id(String)
        case pw(String)
        case signUp
    }
    
    enum Mutation {
        case setID(String)
        case setPw(String)
        case setLogin
        case setError
        case notAuth
        case isEmpty(Bool)
    }
    
    struct State {
        var id: String
        var pw: String
        var result: String?
        var isEnable: Bool
        var complete: Bool
    }
    
    let initialState: State
    private let service: Service
    var steps: PublishRelay<Step> = .init()

    init(_ service: Service) {
        self.service = service
        initialState = State(id: "", pw: "", result: nil, isEnable: false, complete: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signUp:
            steps.accept(BPCheckStep.userIsSignIn)
            return .empty()
        case .id(let id):
            return Observable.concat([.just(Mutation.setID(id)), .just(Mutation.isEmpty(!self.currentState.id.isEmpty && !self.currentState.pw.isEmpty))])
        case .pw(let pw):
            return Observable.concat([.just(Mutation.setPw(pw)), .just(Mutation.isEmpty(!self.currentState.id.isEmpty && !self.currentState.pw.isEmpty))])
        case .doneTap:
            let request: Observable<Mutation> = service.signIn(currentState.id, currentState.pw).asObservable()
                .distinctUntilChanged()
                .map {
                    switch $0 {
                    case .ok:
                        self.steps.accept(BPCheckStep.signInIsRequired)
                        return .setLogin
                    case .conflict:
                        return .notAuth
                    default:
                        return .setError
                    }
                }
            return request
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.complete = false
        newState.result = nil
        switch mutation {
        case .setID(let id):
            newState.id = id
        case .setPw(let pw):
            newState.pw = pw
        case .setLogin:
            newState.complete = true
        case .notAuth:
            newState.result = "아이디 또는 비밀번호가 잘못되었습니다"
        case .isEmpty(let isEmpty):
            newState.isEnable = isEmpty
        default:
            newState.result = "오류로 로그인이 작동하지 않습니다"
        }
        return newState
    }
}

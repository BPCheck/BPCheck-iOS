//
//  SignUpReactor.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/04.
//

import UIKit
import ReactorKit

final class SignUpReactor: Reactor {
    
    enum Action {
        case doneTap
        case id(String)
        case pw(String)
        case name(String)
    }
    
    enum Mutation {
        case setID(String)
        case setPw(String)
        case setName(String)
        case setSignUp
        case setError
        case notAuth
        case isEmpty(Bool)
    }
    
    struct State {
        var id: String
        var pw: String
        var name: String
        var result: String?
        var isEnable: Bool
        var complete: Bool
    }
    
    let initialState: State
    private let service = Service()
    
    init() {
        initialState = State(id: "", pw: "", name: "", result: nil, isEnable: false, complete: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .id(let id):
            return Observable.concat([.just(Mutation.setID(id)), .just(Mutation.isEmpty(!self.currentState.name.isEmpty && !self.currentState.id.isEmpty && !self.currentState.pw.isEmpty))])
        case .pw(let pw):
            return Observable.concat([.just(Mutation.setPw(pw)), .just(Mutation.isEmpty(!self.currentState.name.isEmpty && !self.currentState.id.isEmpty && !self.currentState.pw.isEmpty))])
        case .name(let name):
            return Observable.concat([.just(Mutation.setName(name)), .just(Mutation.isEmpty(!self.currentState.name.isEmpty && !self.currentState.id.isEmpty && !self.currentState.pw.isEmpty))])
        case .doneTap:
            let request: Observable<Mutation> = service.signUp(self.currentState.id, name: self.currentState.name, password: self.currentState.pw).asObservable()
                .map {
                    switch $0 {
                    case .ok:
                        return .setSignUp
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
        switch mutation {
        case .setID(let id):
            newState.id = id
            newState.result = nil
        case .setPw(let pw):
            newState.pw = pw
            newState.result = nil
        case .setName(let name):
            newState.name = name
            newState.result = nil
        case .setSignUp:
            newState.result = nil
            newState.complete = true
        case .notAuth:
            newState.result = "아이디 또는 비밀번호가 잘못되었습니다"
        case .isEmpty(let isEmpty):
            newState.isEnable = isEmpty
        default:
            newState.result = "오류로 로그인이 작동하지 않습니다"
            newState.complete = false
        }
        return newState
    }
}

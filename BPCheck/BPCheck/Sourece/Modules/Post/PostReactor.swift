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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var result: String?
    }
    
    let initialState: State
    private let service = Service()
    
    init() {
        initialState = State()
    }
}

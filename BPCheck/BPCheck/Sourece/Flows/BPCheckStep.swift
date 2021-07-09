//
//  BPCheckStep.swift
//  BPCheck
//
//  Created by 이가영 on 2021/06/09.
//

import RxFlow

enum BPCheckStep: Step {
    case splashIsRequired
    case popViewController
    case dismiss
    
    case signInIsRequired
    case homeIsRequired
    case hospitalIsRequired
    case tabBarIsRequired
    case userIsSignIn
    
    case lowChartIsRequired
    case highChartIsRequired
    case allChartIsRequired
    case presentPanModal
    
    case alert(String)
}

//
//  HospitalFlow.swift
//  BPCheck
//
//  Created by 이가영 on 2021/06/16.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

final class HospitalFlow: Flow {
    private let services: Service
    
    private var rootViewController = UINavigationController().then {
        $0.navigationBar.prefersLargeTitles = true
    }
    
    var root: Presentable {
        return self.rootViewController
    }

    init(services: Service) {
        self.services = services
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BPCheckStep else { return .none }
        
        switch step {
        case .hospitalIsRequired:
            return navigateToHospital()
        default:
            return .none
        }
    }
}

extension HospitalFlow {
    private func navigateToHospital() -> FlowContributors {
        let reactor = HospitalReactor()
        let viewController = HospitalViewController(reactor)
        
        self.rootViewController.setViewControllers([viewController], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}

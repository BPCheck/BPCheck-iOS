//
//  HomeFlow.swift
//  BPCheck
//
//  Created by 이가영 on 2021/06/28.
//

import RxFlow
import RxSwift
import RxCocoa
import PanModal

final class HomeFlow: Flow {
    private let services: Service
    
    private var rootViewController = UINavigationController().then {
        $0.setNavigationBarHidden(true, animated: true)
        $0.navigationBar.isHidden = true
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
        case .homeIsRequired:
            return navigateToHome()
        case .lowChartIsRequired:
            return navigateToLowChart()
        case .highChartIsRequired:
            return navigateToHighChart()
        case .allChartIsRequired:
            return navigateToTableChart()
        case .popViewController:
            return navigateToPop()
        case .presentPanModal:
            return navigateToPresentPanModal()
        default:
            return .none
        }
    }
}

extension HomeFlow {
    private func navigateToHome() -> FlowContributors {
        let reactor = HomeReactor()
        let viewController = HomeViewController(reactor)

        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: reactor))
    }
    
    private func navigateToLowChart() -> FlowContributors {
        let reactor = LowReactor()
        let viewController = LowChartViewController(reactor)
                
        self.rootViewController.setNavigationBarHidden(false, animated: false)
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToHighChart() -> FlowContributors {
        let reactor = HighReactor()
        let viewController = HighChartViewController(reactor)
                
        self.rootViewController.setNavigationBarHidden(false, animated: true)
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPop() -> FlowContributors {
        self.rootViewController.popViewController(animated: false)
        return .none
    }
    
    private func navigateToTableChart() -> FlowContributors {
        let reactor = TableChartsReactor()
        let viewController = TableChartsViewController(reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPresentPanModal() -> FlowContributors {
        let reactor = PostReactor()
        let viewController = PostViewController()
        
        self.rootViewController.presentPanModal(viewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}

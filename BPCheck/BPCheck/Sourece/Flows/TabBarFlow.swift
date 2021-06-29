//
//  TabBarFlow.swift
//  BPCheck
//
//  Created by 이가영 on 2021/06/11.
//

import RxFlow
import RxSwift
import RxCocoa

final class TabBarFlow: Flow {
    private let services: Service
    
    private var rootViewController: UITabBarController
    
    var root: Presentable {
        return rootViewController
    }
    
    init(services: Service) {
        self.services = services
        self.rootViewController = UITabBarController()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BPCheckStep else { return .none }
        
        switch step {
        case .tabBarIsRequired:
            return navigateToTabBar()
        default:
            return .none
        }
    }
}

extension TabBarFlow {
    private func navigateToTabBar() -> FlowContributors {
        let homeFlow = HomeFlow(services: services)
        let hospitalFlow = HospitalFlow(services: services)
        
        Flows.use(homeFlow, hospitalFlow, when: .created) { [unowned self] (root1, root2) in
            let tabBarItem1 = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
            let tabBarItem2 = UITabBarItem(title: "병원", image: UIImage(systemName: "waveform.path.ecg.rectangle"), selectedImage: UIImage(systemName: "waveform.path.ecg.rectangle.fill"))
            
            root1.tabBarItem = tabBarItem1
            root2.tabBarItem = tabBarItem2
            
            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow,
                        withNextStepper: OneStepper(withSingleStep: BPCheckStep.homeIsRequired)),
            .contribute(withNextPresentable: homeFlow,
                        withNextStepper: OneStepper(withSingleStep: BPCheckStep.hospitalIsRequired))
        ])
    }
}

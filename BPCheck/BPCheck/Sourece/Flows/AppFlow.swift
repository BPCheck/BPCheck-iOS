//
//  AppFlow.swift
//  BPCheck
//
//  Created by 이가영 on 2021/06/09.
//

import RxFlow
import RxSwift
import RxCocoa

final class AppFlow: Flow {
    private let window: UIWindow
    private let services: Service
    
    var root: Presentable {
        return self.window
    }
    
    init(window: UIWindow, services: Service) {
        self.window = window
        self.services = services
        window.rootViewController = UINavigationController()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BPCheckStep else { return .none}
        
        switch step {
        case .splashIsRequired:
            return navigateToSignIn()
        case .userIsSignIn:
            return navigateToSignUp()
        case .dismiss:
            return dismiss()
        case .signInIsRequired:
            return navigateToTabBar()
        default:
            return .none
        }
    }
}

extension AppFlow {
    private func navigateToSignIn() -> FlowContributors {
        if let rootViewController = self.window.rootViewController {
            rootViewController.dismiss(animated: true)
        }
        
        let reactor = SignInReactor(services)
        let viewController = SignInViewController(reactor)
        
        self.window.rootViewController = viewController
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTabBar() -> FlowContributors{
        let introFlow = TabBarFlow(services: services)

        Flows.use(introFlow, when: .created) { [unowned self] (root: UITabBarController) in
            self.window.rootViewController = root

            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: [.allowAnimatedContent],
                              animations: nil,
                              completion: nil)
        }

        let nextStep = OneStepper(withSingleStep: BPCheckStep.tabBarIsRequired)
        return .one(flowContributor: .contribute(withNextPresentable: introFlow, withNextStepper: nextStep))
    }
    
    private func navigateToSignUp() -> FlowContributors {
        let reactor = SignUpReactor()
        let viewController = SignUpViewController(reactor)
        viewController.view.backgroundColor = .white
        self.window.rootViewController?.present(viewController, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func dismiss() -> FlowContributors {
        self.window.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        return .none
    }
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let service: Service
    private let disposeBag = DisposeBag()
    
    init(_ service: Service) {
        self.service = service
    }
    
    func readyToEmitSteps() {
        print("hi")
    }
}

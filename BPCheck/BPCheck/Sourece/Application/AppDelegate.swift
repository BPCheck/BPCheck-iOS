//
//  AppDelegate.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/01.
//

import UIKit
import RxSwift
import RxFlow

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var appFlow: AppFlow!
    let service = Service()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        guard let window = self.window else { return false }
        
        coordinator.rx.willNavigate.subscribe(onNext: { flow, step in
            print("\n➡️ will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)
        
        coordinator.rx.didNavigate.subscribe(onNext: { flow, step in
            print("\n➡️ did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)
        let appStepper = OneStepper(withSingleStep: BPCheckStep.splashIsRequired)
        self.appFlow = AppFlow(window: window, services: service)
        coordinator.coordinate(flow: self.appFlow, with: appStepper)

        return true
    }
}


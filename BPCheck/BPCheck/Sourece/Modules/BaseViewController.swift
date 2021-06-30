//
//  BaseViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/06/10.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    var disposeBag: DisposeBag = .init()
    private(set) var didSetupConstraints = false

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    deinit {
        print("DEINIT")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraint()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupConstraint() { }
    
}

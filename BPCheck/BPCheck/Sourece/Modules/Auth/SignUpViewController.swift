//
//  SignUpViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

class SignUpViewController: UIViewController {
    
    private let logoView = UIImageView().then {
        $0.image = UIImage(named: "logoIcon")
    }
    
    private let idTextField = UITextField().then {
        $0.defaultRoundTextField()
        $0.placeholder = "아이디"
    }
    
    private let pwTextField = UITextField().then {
        $0.defaultRoundTextField()
        $0.placeholder = "비밀번호"
    }
    
    private let nameTextField = UITextField().then {
        $0.defaultRoundTextField()
        $0.placeholder = "이름"
    }
    
    private let signUpBtn = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28
        $0.setTitle("회원가입", for: .normal)
        $0.backgroundColor = MainColor.auth
        $0.tintColor = .white
    }
    
    private let disposeBag = DisposeBag()
    private let reactor = SignUpReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(logoView)
        view.addSubview(idTextField)
        view.addSubview(pwTextField)
        view.addSubview(nameTextField)
        view.addSubview(signUpBtn)
        
        setupConstraint()
        self.title = "회원가입"
        bind(reactor: reactor)
    }
    
    func bind(reactor: SignUpReactor) {
        //action
        idTextField.rx.text.orEmpty
            .map{ SignUpReactor.Action.id($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .map{ SignUpReactor.Action.pw($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .map{ SignUpReactor.Action.name($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signUpBtn.rx.tap
            .map{ SignUpReactor.Action.doneTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //state
        reactor.state
            .map { $0.result }
            .filter { $0 != nil}
            .subscribe(onNext: {[unowned self] error in
                showAlert(error!)
            }).disposed(by: disposeBag)

        reactor.state
            .map { $0.complete }
            .subscribe(onNext: {[unowned self]  success in
                if success { navigationController?.popViewController(animated: true) }
            }).disposed(by: disposeBag)

        reactor.state
            .map { $0.isEnable }
            .bind(to: signUpBtn.rx.isEnabled )
            .disposed(by: disposeBag)
    }
    
    private func setupConstraint() {
        
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view.frame.height / 8)
            make.width.equalTo(110)
        }
        
        idTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(logoView.snp.bottom).offset(70)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.leading.equalTo(50)
        }
        
        pwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.leading.equalTo(50)
            make.height.equalTo(50)
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.centerX.equalTo(view)
        }
        
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(40)
            make.trailing.equalTo(nameTextField.snp.trailing)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
        }
    }
}

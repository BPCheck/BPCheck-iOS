//
//  ViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/01.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    
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
        $0.isSecureTextEntry = true
    }
    
    private let signInBtn = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = MainColor.auth
        $0.tintColor = .white
    }
    
    private let signUpBtn = UIButton().then {
        $0.setTitle("계정이 없으신가요?", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
    }
    
    private let disposeBag = DisposeBag()
    private let reactor = SignInReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoView)
        view.addSubview(idTextField)
        view.addSubview(pwTextField)
        view.addSubview(signInBtn)
        view.addSubview(signUpBtn)
        
        setupConstraint()
        bind(reactor: reactor)
        
        signUpBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
            pushViewController("signup")
        }).disposed(by: disposeBag)
        navigationController?.navigationBar.topItem?.title = "로그인"
    }
    
    func bind(reactor: SignInReactor) {
        //action
        idTextField.rx.text.orEmpty.map{
            SignInReactor.Action.id($0)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty.map{
            SignInReactor.Action.pw($0)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        signInBtn.rx.tap
            .map{ SignInReactor.Action.doneTap }
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
                print(success)
                if success { showAlert("Main") }
            }).disposed(by: disposeBag)

        reactor.state
            .map { $0.isEnable }
            .bind(to: signInBtn.rx.isEnabled )
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
            make.height.equalTo(50)
            make.leading.equalTo(50)
        }
        
        pwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.leading.equalTo(50)
            make.height.equalTo(50)
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signUpBtn.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(50)
            make.centerX.equalTo(view)
        }
        
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.trailing.equalTo(pwTextField.snp.trailing)
            make.height.equalTo(50)
        }
    }

}


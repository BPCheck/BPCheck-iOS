//
//  ViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/01.
//

import UIKit
import SnapKit
import Then

class SignInViewController: UIViewController {
    
    private let logoView = UIImageView().then {
        $0.image = UIImage(named: "logoIcon")
    }
    
    private let idTextField = UITextField().then {
        $0.placeholder = "아이디"
        $0.layer.cornerRadius = 20
    }
    
    private let pwTextField = UITextField().then {
        $0.placeholder = "비밀번호"
        $0.layer.cornerRadius = 20
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoView)
        view.addSubview(idTextField)
        view.addSubview(pwTextField)
        view.addSubview(signInBtn)
        view.addSubview(signUpBtn)
        
        setupConstraint()
    }

    private func setupConstraint() {
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view.frame.height / 8)
            make.width.height.equalTo(110)
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


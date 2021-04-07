//
//  HomeViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/04.
//

import UIKit
import SnapKit
import PanModal
import Then
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    private let backImageView = UIImageView().then {
        $0.image = UIImage(named: "background")
    }
    
    private let bpHighView = MainFeedView().then {
        $0.titleLabel.text = "최고"
        $0.iconLabel.image = UIImage(named: "high")
        $0.contentLabel.text = "12"

    }
    
    private let bpLowView = MainFeedView().then {
        $0.titleLabel.text = "최저"
        $0.iconLabel.image = UIImage(named: "low")
        $0.contentLabel.text = "100"
    }
    
    private let pulseView = MainFeedView().then {
        $0.titleLabel.text = "맥박"
    }
    
    private let dateView = MainFeedView().then {
        $0.titleLabel.text = "날짜"
    }
    
    private let updateButton = UIButton().then {
        $0.setTitle("갱신", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = MainColor.update
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 37)
    }
    
    private let hospitalView = MainFeedView().then {
        $0.titleLabel.text = "지정 병원"
        $0.contentLabel.font = UIFont.systemFont(ofSize: 30)
    }

    private let feedLabel = UILabel().then {
        $0.text = "Feed"
        $0.font = UIFont.boldSystemFont(ofSize: 37)
        $0.textColor = .white
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backImageView)
        view.addSubview(bpHighView)
        view.addSubview(bpLowView)
        view.addSubview(pulseView)
        view.addSubview(dateView)
        view.addSubview(hospitalView)
        view.addSubview(updateButton)
        view.addSubview(feedLabel)
        
        setupConstraint()
        
        updateButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            let vc = storyboard?.instantiateViewController(identifier: "post") as! PostViewController
            presentPanModal(vc)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupConstraint() {
        feedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(90)
            make.leading.equalTo(view.snp.leading).offset(27)
        }
        
        backImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        dateView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading).offset(17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(view).offset(view.frame.height / 4)
        }
        
        pulseView.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(view).offset(view.frame.height / 4)
        }
        
        bpLowView.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(pulseView.snp.bottom).offset(50)
        }
        
        bpHighView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading).offset(17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(dateView.snp.bottom).offset(50)
        }
        
        hospitalView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading).offset(17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(bpHighView.snp.bottom).offset(50)
        }
        
        updateButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(bpLowView.snp.bottom).offset(50)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

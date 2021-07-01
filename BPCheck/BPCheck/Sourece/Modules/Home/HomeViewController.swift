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
import ReactorKit

final class HomeViewController: BaseViewController, View {
    typealias Reactor = HomeReactor
    private let backImageView = UIImageView().then {
        $0.image = UIImage(named: "background")
    }
    
    private let bpHighView = MainFeedView().then {
        $0.textLabel.text = "최고"
        $0.iconLabel.image = UIImage(named: "high")
    }
    
    private let bpLowView = MainFeedView().then {
        $0.textLabel.text = "최저"
        $0.iconLabel.image = UIImage(named: "low")
    }
    
    private let pulseView = MainFeedView().then {
        $0.textLabel.text = "맥박"
    }
    
    private let dateView = MainFeedView().then {
        $0.textLabel.text = "날짜"
        $0.contentLabel.adjustsFontSizeToFitWidth = true
        $0.contentLabel.numberOfLines = 1
        $0.contentLabel.font = .systemFont(ofSize: 36)
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
        $0.textLabel.text = "지정 병원"
        $0.contentLabel.font = UIFont.systemFont(ofSize: 30)
    }

    private let feedLabel = UILabel().then {
        $0.text = "Feed"
        $0.font = UIFont.boldSystemFont(ofSize: 37)
        $0.textColor = .white
    }
    
    private let loadData = BehaviorRelay<Void>(value: ())
    
    init(_ reactor: Reactor) {
        super.init()
        
        self.reactor = reactor
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        managerTrait()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func bind(reactor: Reactor) {
        rx.viewWillAppear.map {
            HomeReactor.Action.refresh($0)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        bpLowView.rx.tap.map {
            HomeReactor.Action.lowChart
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        bpHighView.rx.tap.map {
            HomeReactor.Action.highChart
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.main }
            .bind {[unowned self] data in
                guard let data = data?.main else { return }
                bpHighView.contentLabel.text = data.bps[0].highBp
                bpLowView.contentLabel.text = data.bps[0].lowBp
                pulseView.contentLabel.text = data.bps[0].pulse
                hospitalView.contentLabel.text = data.hospitals[0].hospitalName
                dateView.contentLabel.text = data.bps[0].date
            }.disposed(by: disposeBag)
    }
    
    private func managerTrait() {
        updateButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            let vc = storyboard?.instantiateViewController(identifier: "post") as! PostViewController
            presentPanModal(vc)
        }).disposed(by: disposeBag)
    }
    
    override func setupConstraint() {
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
        
        dateView.contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
        }
        
        pulseView.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(view).offset(view.frame.height / 4)
        }
        
        pulseView.contentLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(pulseView.snp.trailing).offset(-30)
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
        
        hospitalView.contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
        }
        
        updateButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(138)
            make.width.equalTo(184)
            make.top.equalTo(bpLowView.snp.bottom).offset(50)
        }
    }
}


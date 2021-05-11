//
//  ChartViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/08.
//

import UIKit
import MSBBarChart
import SnapKit
import ReactorKit
import RxCocoa

class LowChartViewController: UIViewController {

    private let chartView = MSBBarChartView()
    private let titleLabel = UILabel().then {
        $0.text = "최고"
        $0.font = UIFont.boldSystemFont(ofSize: 40)
    }
    private let changeView = UIButton().then {
        $0.setTitle("차트보기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .white
        $0.backgroundColor = MainColor.update
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    
    private let disposeBag = DisposeBag()
    private let reactor = LowReactor()
    private let loadData = PublishRelay<Void>()
    private var allLow = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chartView)
        view.addSubview(titleLabel)
        view.addSubview(changeView)
        
        setupConstraint()
        bind(reactor: reactor)
        loadData.accept(())
        
        changeView.rx.tap.subscribe(onNext: { _ in
            self.pushViewController("tableChart")
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = "최저 혈압 모음"
        chartView.layoutSubviews()
        chartView.start()
    }
    
    private func setupConstraint() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(140)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        chartView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(300)
        }
        
        changeView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func bind(reactor: LowReactor) {
        loadData.map {
            LowReactor.Action.refresh
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.chart }
            .bind {[unowned self] data in
                chartView.setOptions([.yAxisTitle("LowBP"), .yAxisNumberOfInterval(8)])
                chartView.layoutSubviews()
                chartView.start()
                setupBarChart(data)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.result }
            .subscribe(onNext: { message in
                print(message)
            }).disposed(by: disposeBag)
    }
    
    private func setupBarChart(_ data: [LowBp]) {
        for i in data {
            allLow.append(Int(i.lowBp)!)
        }
        print(allLow)
        chartView.setDataEntries(values: allLow)
    }

}

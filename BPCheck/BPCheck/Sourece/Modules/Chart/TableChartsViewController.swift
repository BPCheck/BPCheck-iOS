//
//  TableChartsViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/08.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa

class TableChartsViewController: UIViewController {

    private let tableView = UITableView()
    
    private let titleLabel = UILabel().then {
        $0.text = "최저/고"
        $0.font = UIFont.boldSystemFont(ofSize: 40)
    }
    
    private let changeView = UIButton().then {
        $0.setTitle("그래프 보기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .white
        $0.backgroundColor = MainColor.update
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    
    private let disposeBag = DisposeBag()
    private let reactor = TableChartsReactor()
    private let loadData = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(changeView)
            
        setupConstraint()
        bind(reactor: reactor)
        loadData.accept(())
        setupTableView()
        
        changeView.rx.tap.subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = "모든 혈압 모음"
    }
    
    private func setupConstraint() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(140)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.width.equalTo(view.snp.width)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        changeView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    
    func bind(reactor: TableChartsReactor) {
        loadData.map {
            TableChartsReactor.Action.load
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.map { index in
            TableChartsReactor.Action.deleteEnroll(index)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.chart }
            .bind(to: tableView.rx.items(cellIdentifier: "allCell", cellType: AllBpTableViewCell.self)) { row, data, cell in
                cell.configCell(data)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.result }
            .subscribe(onNext: { message in
                if message == nil {
                    self.loadData.accept(())
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.register(AllBpTableViewCell.self, forCellReuseIdentifier: "allCell")
        tableView.rowHeight = 100
    }

}

//
//  HospitalViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/07.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa

final class HospitalViewController: UIViewController {

    private let hospitalTableView = UITableView()
    private let reactor = HospitalReactor()
    private let disposeBag = DisposeBag()
    private let loadData = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(hospitalTableView)
        setupTableView()
        setupConstraint()
        bind(reactor: reactor)
        loadData.accept(())
    }
    
    private func setupConstraint() {
        hospitalTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func bind(reactor: HospitalReactor) {
        loadData.map {
            HospitalReactor.Action.load
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.hospital }
            .bind(to: hospitalTableView.rx.items(cellIdentifier: "hospitalCell", cellType: UITableViewCell.self)) { row, data, cell in
                cell.textLabel?.text = data.hospitalName
                cell.detailTextLabel?.text = data.hospitalNumber
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.result }
            .subscribe(onNext: { message in
                print(message)
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        hospitalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hospitalCell")
    }

}

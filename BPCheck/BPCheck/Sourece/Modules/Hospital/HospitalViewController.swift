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

final class HospitalViewController: BaseViewController, View {
    typealias Reactor = HospitalReactor
    private let hospitalTableView = UITableView()
    private let loadData = PublishRelay<Bool>()
    private var enrollHospital = PublishRelay<HospitalRegister>()
    
    lazy var enrollButton = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(showEnroll))
    
    init(_ reactor: Reactor) {
        super.init()
        
        self.reactor = reactor
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(hospitalTableView)
                
        setupTableView()
        setupConstraint()
        hospitalTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hospitalTableView.separatorInset = .zero
        navigationItem.rightBarButtonItem = enrollButton
    }
    
    override func setupConstraint() {
        hospitalTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func bind(reactor: HospitalReactor) {
        rx.viewWillAppear.map {
            HospitalReactor.Action.refresh($0)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        loadData.map {
            HospitalReactor.Action.refresh($0)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        hospitalTableView.rx.itemSelected.map { index in
            HospitalReactor.Action.didSelectHospital(index)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        hospitalTableView.rx.itemDeleted.map { index in
            HospitalReactor.Action.deleteFavoritHospital(index)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        enrollHospital.asObservable().map { hospital in
            HospitalReactor.Action.postFavoritHospital(hospital)
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.hospital }
            .bind(to: hospitalTableView.rx.items) { tableView, row, data in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "hospitalCell")
                
                cell.textLabel?.text = data.hospitalName
                cell.detailTextLabel?.text = data.hospitalNumber
                cell.accessoryType = data.isSelect ? .checkmark : .none
                cell.backgroundColor = data.isSelect ? MainColor.update : .clear
                
                return cell
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.result }
            .subscribe(onNext: { message in
                if message == nil {
                    self.loadData.accept((true))
                }else if message != "text"{
                    self.showAlert(message!)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func showEnroll() {
        hospitalAlert()
    }
    
    private func hospitalAlert() {
        let alert = UIAlertController(title: "알림", message: "병원 등록을 하시겠습니까?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.enrollHospital.accept(HospitalRegister(hospitalName: alert.textFields![0].text!,
                                                        hospitalNumber: alert.textFields![1].text!))
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { textField in textField.placeholder = "등록할 병원의 이름을 입력해주세요" }
        alert.addTextField { textField in textField.placeholder = "등록할 병원의 전화번호를 입력해주세요" }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        hospitalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hospitalCell")
        hospitalTableView.rowHeight = 80
    }
}

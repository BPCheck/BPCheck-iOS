//
//  TableChartsViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/08.
//

import UIKit
import SnapKit
import Then

class TableChartsViewController: UIViewController {

    private let tableView = UITableView()
    
    private let titleLabel = UILabel().then {
        $0.text = "최저/고"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(changeView)
            
        setupConstraint()
    }
    
    private func setupConstraint() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(140)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        tableView.snp.makeConstraints { (make) in
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

}

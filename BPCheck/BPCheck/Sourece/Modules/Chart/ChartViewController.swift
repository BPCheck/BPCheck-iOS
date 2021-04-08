//
//  ChartViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/08.
//

import UIKit
import MSBBarChart
import SnapKit

class ChartViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chartView)
        view.addSubview(titleLabel)
        
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupBarChart()
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
    }
    
    private func setupBarChart() {
        chartView.setOptions([.yAxisTitle("成長"), .yAxisNumberOfInterval(10)])
        chartView.layoutSubviews()
        chartView.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
        chartView.setDataEntries(values: [12,24,36,48,60,72,84,96,12,24,36,48,60,72,84,96, 12,24,36,48,60,72,84,96,12,24,36,48,60,72,84,96])
        chartView.setXAxisUnitTitles(["繊維","IT","鉄鋼","繊維","リテール","不動産","人材派遣","銀行","IT","鉄鋼","繊維","リテール","不動産","人材派遣","銀行"])
        chartView.start()
    }

}

//
//  PostViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/07.
//

import UIKit
import PanModal
import Then

class PostViewController: UIViewController {
    
    private let recognizingText = UIButton().then{
        $0.setTitle("간편 사진 인식", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .white
        $0.backgroundColor = MainColor.update
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    
    private let updateButton = UIButton().then {
        $0.setTitle("갱신", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .white
        $0.backgroundColor = MainColor.auth
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    
    private let highLabel = UILabel().then {
        $0.text = "최고"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let highPickerView = UIPickerView()
    
    private let lowLabel = UILabel().then {
        $0.text = "최저"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let lowPickerView = UIPickerView()
    
    private let pulseLabel = UILabel().then {
        $0.text = "맥박"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let pulsePickerView = UIPickerView()
    
    private let dateLabel = UILabel().then {
        $0.text = "날짜"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let datePickerView = UIDatePicker().then {
        $0.datePickerMode = .date
    }
    private var counter = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(highPickerView)
        view.addSubview(highLabel)
        view.addSubview(lowPickerView)
        view.addSubview(lowLabel)
        view.addSubview(pulsePickerView)
        view.addSubview(pulseLabel)
        view.addSubview(dateLabel)
        view.addSubview(datePickerView)
        view.addSubview(recognizingText)
        view.addSubview(updateButton)
        
        for i in 1...200 { counter.append(String(i)) }
        
        highPickerView.dataSource = self
        highPickerView.delegate = self
        
        lowPickerView.dataSource = self
        lowPickerView.delegate = self
        
        pulsePickerView.dataSource = self
        pulsePickerView.delegate = self
        
        setupConstraint()
        
    }
    

    private func setupConstraint() {
        highLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        highPickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(highLabel)
            make.leading.equalTo(highLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        lowLabel.snp.makeConstraints { (make) in
            make.top.equalTo(highLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        lowPickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lowLabel)
            make.leading.equalTo(lowLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        pulseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lowLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        pulsePickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(pulseLabel)
            make.leading.equalTo(pulseLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pulseLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        datePickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(pulsePickerView.snp.leading)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        updateButton.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(40)
            make.leading.equalTo(dateLabel.snp.leading)
            make.width.equalTo(156)
            make.height.equalTo(50)
        }
        
        recognizingText.snp.makeConstraints { (make) in
            make.top.equalTo(updateButton.snp.top)
            make.leading.equalTo(updateButton.snp.trailing).offset(17)
            make.width.equalTo(156)
            make.height.equalTo(50)
        }
    }
    
}

extension PostViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var shouldRoundTopCorners: Bool {
        return true
    }
}

extension PostViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return counter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return counter[row]
    }
}

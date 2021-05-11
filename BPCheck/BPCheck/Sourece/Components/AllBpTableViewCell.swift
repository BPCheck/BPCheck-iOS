//
//  AllBpTableViewCell.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/27.
//

import UIKit

class AllBpTableViewCell: UITableViewCell {

    let highLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30)
    }
    
    let lowLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30)
    }
    
    let currentDateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(highLabel)
        addSubview(lowLabel)
        addSubview(currentDateLabel)
        
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configCell(_ data: Bp) {
        highLabel.text = data.highBp
        lowLabel.text = data.lowBp
        currentDateLabel.text = data.date
    }
    
    private func setupConstraint() {
        currentDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24)
            make.centerY.equalToSuperview()
        }
        
        lowLabel.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.centerY.equalToSuperview()
        }
        
        highLabel.snp.makeConstraints { make in
            make.trailing.equalTo(lowLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}

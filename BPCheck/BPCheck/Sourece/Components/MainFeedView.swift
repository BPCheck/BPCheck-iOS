//
//  MainFeedView.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/05.
//

import UIKit
import SnapKit

class MainFeedView: UIButton {
    
    let textLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 27)
    }
    
    let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 50)
    }
    
    let iconLabel = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = 30
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        backgroundColor = .white
        
        addSubview(textLabel)
        addSubview(contentLabel)
        addSubview(iconLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(20)
            make.leading.equalTo(snp.leading).offset(30)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.leading.lessThanOrEqualTo(snp.leading).offset(84)
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.trailing.lessThanOrEqualTo(snp.trailing).offset(-10)
            make.width.lessThanOrEqualTo(150)
        }
        
        iconLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentLabel.snp.leading).offset(-15)
            make.centerY.equalTo(contentLabel)
            make.height.equalTo(18)
            make.width.equalTo(15)
        }
        
    }

}

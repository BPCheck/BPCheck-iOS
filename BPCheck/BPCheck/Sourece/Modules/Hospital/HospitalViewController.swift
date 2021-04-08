//
//  HospitalViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/07.
//

import UIKit
import SnapKit
import Then

class HospitalViewController: UIViewController {

    private let hospitalTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(hospitalTableView)
        setupConstraint()
    }
    
    private func setupConstraint() {
        hospitalTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

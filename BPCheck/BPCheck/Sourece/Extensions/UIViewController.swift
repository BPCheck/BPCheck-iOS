//
//  UIViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/03.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: "알람", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func pushViewController(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
}

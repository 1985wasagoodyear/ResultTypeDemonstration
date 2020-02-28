//
//  UIKit+Utility.swift
//  Created 2/28/20
//  Using Swift 5.0
// 
//  Copyright © 2020 Yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

extension UIView {
    func fillIn(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let constraints = [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension UIViewController {
    func showAlert(text: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: text,
                                          message: nil,
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
    

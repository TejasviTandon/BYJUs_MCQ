//
//  UIVIewController + Alert.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(withTitle title: String, message: String, okayButtonAction okAction:String?, andCancelButton cancelButton : String?, completion : @escaping (Bool) -> Void) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        if let okTitle = okAction {
            let okAction = UIAlertAction(title: okTitle, style: .default) { (_) in
                completion(true)
            }
            alertView.addAction(okAction)
        }
        if let cancelTitle = cancelButton {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { (_) in
                completion(false)
            }
            alertView.addAction(cancelAction)
        }
        present(alertView, animated: true, completion: nil)
    }
}

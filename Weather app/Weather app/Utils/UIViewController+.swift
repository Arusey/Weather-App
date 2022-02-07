//
//  UIViewController+.swift
//  Weather app
//
//  Created by Kevin Lagat on 07/02/2022.
//

import Foundation
import UIKit


extension UIViewController {
    func showError(error:Error) {
        let alertVC = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

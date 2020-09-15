//
//  UIViewController+extension.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

extension UIViewController {
// MARK: AlertGestion
    struct AlertMessage {
        // Program or Internet errors
        let programError = "ProgramErr".localizedString()
        let errorInternet = "InternetErr".localizedString()

        // Connexion error
        let loginTextFieldsEmpty = "LogTextField".localizedString()

        // Reset password alert
        let resetMessage = "ResetMessage".localizedString()

        // Practice section error
        let didntChoose = "Didnt choose".localizedString()
    }

    func presentAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: Child gestion
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

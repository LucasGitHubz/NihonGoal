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
        let programError = "L'application a rencontré une erreur inconnue. Veuillez la redémarrer."
        let errorInternet = "Vérifiez que votre connexion internet est bien active, puis recommencez."

        // Connexion error
        let loginTextFieldsEmpty = "Veuillez saisir votre e-mail ainsi que votre mot de passe avant de continuer."

        // Reset password alert
        let resetMessage = "Un mail de réinitialisation a été envoyé sur votre adresse mail !"

        // Practice section error
        let didntChoose = "Veuillez sélectionner au moins une colonne avant de continuer"
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

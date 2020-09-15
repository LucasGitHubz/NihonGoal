//
//  SignInViewController.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import TextFieldEffects
import TransitionButton

class SignInViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signInButton: TransitionButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    // MARK: Properties
    private let userController = UserController()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalizedString()
    }
    
    // MARK: Methods
    func setLocalizedString() {
        cancelButton.setTitle("Cancel".localizedString(), for: .normal)
        passwordTextField.placeholder = "Password".localizedString()
        signInButton.setTitle("Sign in".localizedString(), for: .normal)
    }
    private func checkIfTextFieldsAreNotEmpty(_ email: String, _ password: String) -> Bool {
        if email == "" || password == "" {
            return false
        }
        return true
    }
    
    private func processToAuthentification(_ email: String, _ password: String, button: TransitionButton) {
        if checkIfTextFieldsAreNotEmpty(email, password) {
            userController.connexion(email: email, password: password) { (error) in
                if error != nil {
                    button.stopAnimation(animationStyle: .shake) {
                        self.presentAlert(message: error?.errorDescription() ?? "", title: "Oups !")
                    }
                } else {
                    button.stopAnimation(animationStyle: .expand) {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func didTapConnexionButton(_ sender: TransitionButton) {
        sender.startAnimation()
        processToAuthentification(emailTextField.text ?? "", passwordTextField.text ?? "", button: sender)
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

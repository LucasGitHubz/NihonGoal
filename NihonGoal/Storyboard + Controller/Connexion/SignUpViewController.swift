//
//  SignUpViewController.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import TextFieldEffects
import TransitionButton

class SignUpViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!

    // MARK: Properties
    private let userController = UserController()

    // MARK: Methods
    func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    private func validateTextField() -> String? {
        guard nameTextField.text != "" ||
            firstNameTextField.text != "" ||
            emailTextField.text != "" ||
            passwordTextField.text != "" else {
                return "Veuillez remplir tous les champs avant de continuer."
        }
        
        guard let password = passwordTextField.text else {
            return "Votre mot de passe doit contenir au moins 8 charactères, dont un chiffre et un caractère spécial."
        }
        
        guard isPasswordValid(password) else {
            return "Votre mot de passe doit contenir au moins 8 charactères, dont un chiffre et un caractère spécial."
        }

        guard password == confirmPasswordTextField.text else {
            return "Les mots de passe de correspondent pas."
        }
        
        return nil
    }

    private func signUp(button: TransitionButton) {
        button.startAnimation()
        let error = validateTextField()
        let email = emailTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        guard error == nil else {
            button.stopAnimation(animationStyle: .shake, revertAfterDelay: 2) {
                self.presentAlert(message: error ?? AlertMessage().programError, title: "Oups !")
            }
            return
        }
        
        userController.inscription(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                button.stopAnimation(animationStyle: .shake, revertAfterDelay: 2) {
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                }
            case .success(let result):
                self.userController.addNewUserToDB(lastName: lastName, firstName: firstName, uid: result.user.uid, email: email, hiraganaTab: [], katakanaTab: []) { (success) in
                    if success {
                        button.stopAnimation(animationStyle: .expand) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        button.stopAnimation(animationStyle: .shake, revertAfterDelay: 2) {
                            self.presentAlert(message: error ?? AlertMessage().programError, title: "Oups !")
                        }
                    }
                }
            }
        }
    }

    // MARK: IBAction
    @IBAction func didTapSignUpButton(_ sender: TransitionButton) {
        signUp(button: sender)
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

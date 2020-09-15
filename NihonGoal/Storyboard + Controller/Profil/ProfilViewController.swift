//
//  ProfilViewController.swift
//  NihonGoal
//
//  Created by kuroro on 04/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable
import FirebaseAuth
import FirebaseFirestore

class ProfilViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var barItem: UITabBarItem!
    @IBOutlet weak var helloLabel: CustomConnexionLabel!
    @IBOutlet weak var progressLabel: CustomConnexionLabel!
    @IBOutlet weak var masteringLabel: CustomConnexionLabel!
    @IBOutlet weak var resetLabel: CustomConnexionLabel!
    @IBOutlet weak var signOutLabel: CustomConnexionLabel!
    @IBOutlet weak var hiraganaLabel: UILabel!
    @IBOutlet weak var katakanaLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: Properties
    private lazy var loadingController = LoadingViewController()
    private let userController = UserController()
    private var name = String()
    private var hiraganaTab = [String]()
    private var katakanaTab = [String]()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalizedString()
        backgroundImage.blurImage()
        getDocument()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getDocument()
    }

    // MARK: Methods
    func setLocalizedString() {
        progressLabel.text = "Progress".localizedString()
        masteringLabel.text = "Mastering".localizedString()
        resetLabel.text = "Reset".localizedString()
        signOutLabel.text = "Sign out".localizedString()
    }

    private func getDocument() {
        add(loadingController)
        userController.getUser { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userDatas):
                    self.name = userDatas.name
                    self.hiraganaTab = userDatas.hiraganaTab
                    self.katakanaTab = userDatas.katakanTab
                    self.helloLabel.text = "Hey \(userDatas.name) !"
                    self.hiraganaLabel.text = "Hiragana: \((self.hiraganaTab.count * 100) / 104)%"
                    self.katakanaLabel.text = "Katakana: \((self.katakanaTab.count * 100) / 104)%"
                    self.loadingController.remove()
                case .failure(_):
                    self.logOut()
                    self.loadingController.remove()
                }
            }
        }
    }

    func resetPassword() {
        add(loadingController)
        userController.resetPassword(email: Auth.auth().currentUser?.email ?? "") { (success) in
            DispatchQueue.main.async {
                if success {
                    self.loadingController.remove()
                    self.presentAlert(message: AlertMessage().resetMessage, title: "Reset message".localizedString())
                } else {
                    self.loadingController.remove()
                    self.presentAlert(message: AlertMessage().errorInternet, title: "Error message".localizedString())
                }
            }
        }
    }

    func logOut() {
        add(loadingController)
        userController.signOut { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentAlert(message: AlertMessage().programError, title: "Oups !")
                }
            }
        }
    }

    // MARK: IBActions
    @IBAction func didTapNetworkButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToNetworks", sender: self)
    }

    @IBAction func didTapResetPasswordButton(_ sender: Any) {
        resetPassword()
    }

    @IBAction func didTapLogOutButton(_ sender: Any) {
        logOut()
    }
}

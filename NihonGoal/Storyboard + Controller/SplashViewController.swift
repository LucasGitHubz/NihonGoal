//
//  SplashViewController.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {
    private let connexionVC = ConnexionViewController.instantiate()
    private let tabBarVC = TabBarController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listenAuthState()
    }

    func listenAuthState() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.add(self.tabBarVC)
            } else {
                self.add(self.connexionVC)
            }
        }
    }
}

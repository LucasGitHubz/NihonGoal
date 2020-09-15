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
    private let connexionVC = ConnectionViewController.instantiate()
    private let tabBarVC = TabBarController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listenAuthState()
    }

    func listenAuthState() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.connexionVC.remove()
                self.add(self.tabBarVC)
            } else {
                self.tabBarVC.remove()
                self.add(self.connexionVC)
            }
        }
    }
}

//
//  ConnexionViewController.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class ConnectionViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var signInButton: CustomConnexionButton!
    @IBOutlet weak var signUpButton: CustomConnexionButton!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.setTitle("Sign in".localizedString(), for: .normal)
        signUpButton.setTitle("Sign up".localizedString(), for: .normal)
    }
}

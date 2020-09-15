//
//  HomeController.swift
//  NihonGoal
//
//  Created by kuroro on 04/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class TabBarController: UITabBarController, StoryboardBased {
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers?[3].tabBarItem.title = "Practice".localizedString()
        viewControllers?[4].tabBarItem.title = "Profile".localizedString()
    }
}

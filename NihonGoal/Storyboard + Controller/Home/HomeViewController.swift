//
//  HomeViewController.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Hero
import Reusable

class HomeViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var hiraganaBubble: UIImageView!
    @IBOutlet weak var katakanaBubble: UIImageView!
    @IBOutlet weak var practiceBubble: UIImageView!
    @IBOutlet weak var practiceButton: CustomHomeButton!
    
    // MARK: Properties
    private let bubbleAnimationController = BubbleViewController.instantiate()
    private let hiraganaVC = HiraganaViewController.instantiate()
    private let katakanaVC = KatakanaViewController.instantiate()
    private let practiceNavVC = PracticeNavigationController.instantiate()
    private var initialHeightTab = [CGFloat]()
    private var initialWidthTab = [CGFloat]()
    private var bubbleImageTab = [UIImageView]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        practiceButton.setTitle(NSLocalizedString("Practice", comment: ""), for: .normal)
        bubbleImageTab = [hiraganaBubble, katakanaBubble, practiceBubble]
        
        initialHeightTab = bubbleImageTab.compactMap({ $0.frame.size.height })
        initialWidthTab = bubbleImageTab.compactMap({ $0.frame.size.height })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for index in 0...bubbleImageTab.count - 1 {
            bubbleImageTab[index].frame.size.height = initialHeightTab[index]
            bubbleImageTab[index].frame.size.width = initialWidthTab[index]
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateBubble()
    }
    
    // MARK: IBActions
    @IBAction func didTapHiraganaButton(_ sender: Any) {
        launchMultipleBubbleAnimation(unwindSegue: "unwindToHiragana", viewController: hiraganaVC)
    }
    
    @IBAction func didTapKatakanaButton(_ sender: Any) {
        launchMultipleBubbleAnimation(unwindSegue: "unwindToKatakana", viewController: katakanaVC)
    }
    
    @IBAction func didTapPracticeButton(_ sender: Any) {
        launchMultipleBubbleAnimation(unwindSegue: "unwindToPractice", viewController: practiceNavVC)
    }

    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
    }
}

// MARK: Bubbles animation
extension HomeViewController {
    private func animateBubble() {
        let options: UIView.AnimationOptions = [.curveEaseInOut,
                                                .repeat,
                                                .autoreverse]
        
        UIView.animate(withDuration: 3,
                       delay: 0.6,
                       options: options,
                       animations: { [weak self] in
                        self?.hiraganaBubble.frame.size.height *= 1.05
                        self?.hiraganaBubble.frame.size.width *= 1.05
            }, completion: nil)
        
        UIView.animate(withDuration: 2.7,
                       delay: 0,
                       options: options,
                       animations: { [weak self] in
                        self?.katakanaBubble.frame.size.height *= 1.03
                        self?.katakanaBubble.frame.size.width *= 1.03
            }, completion: nil)
        
        UIView.animate(withDuration: 2.4,
                       delay: 0.3,
                       options: options,
                       animations: { [weak self] in
                        self?.practiceBubble.frame.size.height *= 1.04
                        self?.practiceBubble.frame.size.width *= 1.04
            }, completion: nil)
    }
    
    private func launchMultipleBubbleAnimation(unwindSegue: String, viewController: UIViewController) {
        add(viewController)
        add(bubbleAnimationController)
        
        viewController.view.layer.opacity = 0
        
        UIView.animate(withDuration: 3,
                       delay: 0,
                       animations: { [] in
                        viewController.view.layer.opacity = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            self.bubbleAnimationController.remove()
            self.performSegue(withIdentifier: unwindSegue, sender: self)
            viewController.remove()
        }
    }
}

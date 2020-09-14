//
//  BubbleViewController.swift
//  NihonGoal
//
//  Created by kuroro on 07/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class BubbleViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet var viewBottomConstraint: [NSLayoutConstraint]!
    @IBOutlet var bubbleLeadingConstraint: [NSLayoutConstraint]!

    // MARK: Properties
    private let randomSequence: [CGFloat] = [100, 300, -110, -60, 70, -150, 220, 255, -210, 300, -280, -105, -250, 108, 5, 70, 90, -188, -20, 130, -38, -247, 99]
    private var bubbleCounter = 0
    private var bubbleLeadingConstraintTab = [NSLayoutConstraint]()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewStartPosition(viewConstraintTab: viewBottomConstraint)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setViewDidAppearPosition(viewBottomConstraint)
        
        startBubbleAnimation(bubbleConstraintTab: bubbleLeadingConstraint)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        for constraint in bubbleLeadingConstraint {
            constraint.constant = 20
        }

        bubbleCounter = 0
        setViewStartPosition(viewConstraintTab: viewBottomConstraint)
        
    }

    // MARK: Methods
    private func setViewStartPosition(viewConstraintTab: [NSLayoutConstraint]) {
        var constantCounter: CGFloat = 0.0

        for constraint in viewConstraintTab {
            constraint.constant = (200) + constantCounter
            constantCounter += 20.0
        }
    }
    
    func setViewDidAppearPosition(_ viewConstraintTab: [NSLayoutConstraint]) {
        for index in 0...viewConstraintTab.count - 1 {
            viewConstraintTab[index].constant -= (2.2 * view.bounds.height)
        }
        
        startBubbleViewAnimation()
    }
    
    func startBubbleViewAnimation() {
        UIView.animate(withDuration: 3.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func startBubbleAnimation(bubbleConstraintTab: [NSLayoutConstraint]) {
        bubbleLeadingConstraintTab = bubbleConstraintTab
        
        let randomConstant = CGFloat.random(in: -400..<400)
        
        guard bubbleCounter != bubbleConstraintTab.count - 1 else {
            return
        }

        UIView.animate(withDuration: 2.5,
                       delay: 0,
                       animations: { [weak self] in
                        self?.bubbleLeadingConstraintTab[self?.bubbleCounter ?? 0].constant += self?.randomSequence[self?.bubbleCounter ?? 0] ?? randomConstant
                        self?.view.layoutIfNeeded()
                        self?.bubbleCounter += 1
                        self?.startBubbleAnimation(bubbleConstraintTab: self?.bubbleLeadingConstraintTab ?? [NSLayoutConstraint]())
        })
    }

    func stopAnimation() {
        setViewStartPosition(viewConstraintTab: viewBottomConstraint)
        for index in 0...bubbleLeadingConstraint.count - 1 {
            bubbleLeadingConstraint[index].constant -= randomSequence[index]
        }
    }
}

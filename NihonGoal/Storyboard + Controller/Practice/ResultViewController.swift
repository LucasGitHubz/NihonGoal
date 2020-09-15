//
//  ResultViewController.swift
//  NihonGoal
//
//  Created by kuroro on 10/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

struct CongratulationSentence {
    let worstScore = "Worst score".localizedString()
    let badScore = "Bad score".localizedString()
    let okScore = "Ok score".localizedString()
    let goodScore = "Good score".localizedString()
    let maxScore = "Max score".localizedString()
}

class ResultViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var exerciseOverLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var congratzLabel: UILabel!
    
    // MARK: Properties
    private var timer = Timer()
    private var time = Double()

    var totalQuestion = Int()
    var modeIndicator: ExerciseMode = .zen
    var score = Int()
    var averageTime = Double()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        exerciseOverLabel.text = "Exercise over".localizedString()
        animateScoreLabelByLaunchingTimer()
    }

    // MARK: Methods

    // MARK: --------------------------------- Animate labels methods ---------------------------------
    private func animateScoreLabelByLaunchingTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(timeDidEnded), userInfo: nil, repeats: true)
    }
    
    @objc private func timeDidEnded() {
        time += 1
        
        if String(format: "%.f", time) == "\(score)" {
            scoreLabel.text = "Score = \(String(format: "%.f", time))/\(totalQuestion)"
            time = 0.0
            timer.invalidate()
            if modeIndicator == .fast {
                animateAverageLabelByLaunchingTimer()
            } else {
                animateCongratzLabel(sentence: pullOutCongratzSentence())
            }
        } else {
            scoreLabel.text = "Score = \(String(format: "%.f", time))/\(totalQuestion)"
        }
    }

    private func animateAverageLabelByLaunchingTimer() {
        averageTimeLabel.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(averageTimeDidEnded), userInfo: nil, repeats: true)
    }
    
    @objc private func averageTimeDidEnded() {
        time += 0.01
        
        if String(format: "%.2f", time) == String(format: "%.2f", averageTime) {
            averageTimeLabel.text = "Average time".localizedString() +  "\(String(format: "%.2f", time))s"
            timer.invalidate()
            animateCongratzLabel(sentence: pullOutCongratzSentence())
        } else {
            averageTimeLabel.text = "Average time".localizedString() +  "\(String(format: "%.2f", time))s"
        }
    }

    // MARK: --------------------------------- Set congratz label method ---------------------------------
    private func pullOutCongratzSentence() -> String {
        switch score {
        case 0:
            return CongratulationSentence().worstScore
        case 1..<(totalQuestion/2):
            return CongratulationSentence().badScore
        case (totalQuestion/2):
            return CongratulationSentence().okScore
        case (totalQuestion/2 + 1)..<totalQuestion:
            return CongratulationSentence().goodScore
        case totalQuestion:
            return CongratulationSentence().maxScore
        default:
            presentAlert(message: AlertMessage().programError, title: "Oups !")
        }
        return ""
    }

    // MARK: IBActions
    @IBAction func didTapReplayButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMenu", sender: self)
    }
}

// MARK: Animation gestion
extension ResultViewController {
    private func animateCongratzLabel(sentence: String) {
        congratzLabel.layer.opacity = 0
        congratzLabel.text = sentence
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       animations: { [] in
                        self.congratzLabel.layer.opacity = 1
        })
    }
}

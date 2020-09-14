//
//  ExerciceViewController.swift
//  NihonGoal
//
//  Created by kuroro on 08/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

enum Direction {
    case kanaToLetter, letterToKana
}

class ExerciseViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: Properties
    private let kana = Kana()
    private var fullAnswersTab = [String]()
    private var modeIndicator: ExerciseMode = .zen
    private var direction: Direction = .kanaToLetter

    var buttonTag = Int()
    var kanaTab = [[String]]()
    var letterTab = [[String]]()
    var typeOfKana: TypeOfKana = .hiragana

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        setInterface()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    // MARK: Methods
    func setInterface() {
        switch buttonTag {
        case 1:
            titleLabel.text = "あ → a"
            direction = .kanaToLetter
            fullAnswersTab = kana.setTab(tab: (kana.letterTab + kana.letterDerives + kana.letterDiphtongues + kana.letterDerivesDiphtongues))
        case 2:
            titleLabel.text = "a → あ"
            direction = .letterToKana
            fullAnswersTab = kana.setTab(tab: (kana.hiraganaTab + kana.hiraganaDerives + kana.hiraganaDiphtongues + kana.hiraganaDerivesDiphtongues))
        case 3:
            titleLabel.text = "ア → a"
            direction = .kanaToLetter
            fullAnswersTab = kana.setTab(tab: (kana.letterTab + kana.letterDerives + kana.letterDiphtongues + kana.letterDerivesDiphtongues))
        case 4:
            titleLabel.text = "a → ア"
            direction = .letterToKana
            fullAnswersTab = kana.setTab(tab: (kana.katakanaTab + kana.katakanaDerives + kana.katakanaDiphtongues + kana.katakanaDerivesDiphtongues))
        default:
            presentAlert(message: AlertMessage().programError, title: "Oups !")
        }
    }

    // MARK: IBActions
    @IBAction func didTapZenButton(_ sender: Any) {
        modeIndicator = .zen

        performSegue(withIdentifier: "segueToExercise", sender: self)
    }
    
    @IBAction func didTapFastButton(_ sender: Any) {
        modeIndicator = .fast

        performSegue(withIdentifier: "segueToExercise", sender: self)
    }
}

// MARK: Perpare segue gestion
extension ExerciseViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToExercise" {
            guard let successVC = segue.destination as? ExerciseModeViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successVC.typeOfKana = typeOfKana
            successVC.fullAnswersTab = fullAnswersTab
            successVC.kanaTab = kanaTab
            successVC.letterTab = letterTab
            successVC.direction = direction
            successVC.modeIndicator = modeIndicator
        }
    }
}

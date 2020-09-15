//
//  PracticeViewController.swift
//  NihonGoal
//
//  Created by kuroro on 06/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

enum TypeOfKana {
    case hiragana, katakana
}

protocol ExerciseDelegateProtocol {
    func checkTab() -> Bool
    func fillTabs(kanas: [String], letters: [String])
    func deleteRowFromTabs(kanas: [String])
    func goToExerciseVC()
    func back()
}

class PracticeViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var navItem: UINavigationItem!
    
    // MARK: Properties
    private var buttonTag = Int()
    private var kanaTab = [[String]]()
    private var letterTab = [[String]]()
    private var typeOfKana: TypeOfKana = .hiragana
    
    // MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setLocalizedString()
        kanaTab.removeAll()
        letterTab.removeAll()
    }

    // MARK: Methods
    func setLocalizedString() {
        navItem.title = "Practice".localizedString()
    }
    
    // MARK: IBActions
    @IBAction func didTapExerciceButtons(_ sender: Any) {
        guard let button = sender as? UIButton else {
            presentAlert(message: AlertMessage().programError, title: "Oups !")
            return
        }
        
        buttonTag = button.tag
        if button.tag == 1 || button.tag == 2 {
            typeOfKana = .hiragana
            performSegue(withIdentifier: "segueToHiraganaSelection", sender: self)
        } else {
            typeOfKana = .katakana
            performSegue(withIdentifier: "segueToKatakanaSelection", sender: self)
        }
    }
    
    @IBAction func unwindToPractice(segue:UIStoryboardSegue) {
    }
}

// MARK: Prepare for segue
extension PracticeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToHiraganaSelection" {
            guard let successVC = segue.destination as? HiraganaSelectionViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }
            
            successVC.delegate = self
        }
        
        if segue.identifier == "segueToKatakanaSelection" {
            guard let successVC = segue.destination as? KatakanaSelectionViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }
            
            successVC.delegate = self
        }
        
        if segue.identifier == "segueToExerciseVC" {
            guard let successVC = segue.destination as? ExerciseViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successVC.typeOfKana = typeOfKana
            successVC.kanaTab = kanaTab
            successVC.letterTab = letterTab
            successVC.buttonTag = buttonTag
        }
    }
}

extension PracticeViewController: ExerciseDelegateProtocol {
    func checkTab() -> Bool {
        guard kanaTab.count != 0 else {
            return false
        }
        return true
    }
    
    func fillTabs(kanas: [String], letters: [String]) {
        guard kanaTab.count != 27 else {
            return
        }
        
        guard kanaTab.count > 0 else {
            kanaTab.append(kanas)
            letterTab.append(letters)
            print("0 \(kanaTab)")
            return
        }
        
        for index in 0...kanaTab.count - 1 where kanaTab[index] == kanas {
            print("same \(kanaTab)")
            return
        }

        kanaTab.append(kanas)
        letterTab.append(letters)
        print(kanaTab)
        print(kanaTab.count)
    }

    func deleteRowFromTabs(kanas: [String]) {
        guard kanaTab.count > 0 else {
            return
        }

        for index in 0...kanaTab.count - 1 where kanaTab[index] == kanas {
            kanaTab.remove(at: index)
            letterTab.remove(at: index)
            print(kanaTab)
            return
        }
    }

    func goToExerciseVC() {
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "segueToExerciseVC", sender: self)
    }

    func back() {
        dismiss(animated: true, completion: nil)
        kanaTab.removeAll()
        letterTab.removeAll()
    }
}

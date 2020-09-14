//
//  KatakanaSelectionViewController.swift
//  NihonGoal
//
//  Created by kuroro on 09/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class KatakanaSelectionViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var sections = [KanaDatasType]()
    private let kana = Kana()
    var delegate: ExerciseDelegateProtocol?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSections()
        backgroundView.setGradient(firstColor: #colorLiteral(red: 1, green: 0.690285027, blue: 0.402682364, alpha: 1), secondColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), rounded: false)
        tableView.backgroundColor = .clear
    }
    
    // MARK: IBActions
    @IBAction func didTapSelectAllRowsButton(_ sender: Any) {
        selectAllRows()
    }

    @IBAction func didTapDeselectAllRowsButton(_ sender: Any) {
        deselectAllRows()
    }

    @IBAction func didTapReturnButton(_ sender: Any) {
        deselectAllRows()
        delegate?.back()
    }
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        guard delegate?.checkTab() ?? true else {
            presentAlert(message: AlertMessage().didntChoose, title: "Oups !")
            return
        }
        delegate?.goToExerciseVC()
    }
}

// MARK: TableView gestion
extension KatakanaSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    private func selectAllRows() {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
            }
        }
    }
    
    private func deselectAllRows() {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = tableView.delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
            }
        }
        self.tableView.reloadData()
    }
    
    private func addRowToTab(indexPath: Int, section: Int) {
        switch section {
        case 0:
            delegate?.fillTabs(kanas: kana.katakanaTab[indexPath], letters: kana.letterTab[indexPath])
        case 1:
            delegate?.fillTabs(kanas: kana.katakanaDerives[indexPath], letters: kana.letterDerives[indexPath])
        case 2:
            delegate?.fillTabs(kanas: kana.katakanaDiphtongues[indexPath], letters: kana.letterDiphtongues[indexPath])
        case 3:
            delegate?.fillTabs(kanas: kana.katakanaDerivesDiphtongues[indexPath], letters: kana.letterDerivesDiphtongues[indexPath])
        default:
            presentAlert(message: AlertMessage().programError, title: "Oups !")
        }
    }
    
    private func deleteRowFromTab(indexPath: Int, section: Int) {
        switch section {
        case 0:
            delegate?.deleteRowFromTabs(kanas: kana.katakanaTab[indexPath])
        case 1:
            delegate?.deleteRowFromTabs(kanas: kana.katakanaDerives[indexPath])
        case 2:
            delegate?.deleteRowFromTabs(kanas: kana.katakanaDiphtongues[indexPath])
        case 3:
            delegate?.deleteRowFromTabs(kanas: kana.katakanaDerivesDiphtongues[indexPath])
        default:
            presentAlert(message: AlertMessage().programError, title: "Oups !")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addRowToTab(indexPath: indexPath.row, section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deleteRowFromTab(indexPath: indexPath.row, section: indexPath.section)
    }
    
    func setSections() {
        sections.append(KanaDatasType.init(title: NSLocalizedString("Fundamental characters", comment: ""), kanaTab: kana.katakanaTab, letterTab: kana.letterTab))
        sections.append(KanaDatasType.init(title: NSLocalizedString("Derivatives", comment: ""), kanaTab: kana.katakanaDerives, letterTab: kana.letterDerives))
        sections.append(KanaDatasType.init(title: NSLocalizedString("Diphthongs", comment: ""), kanaTab: kana.katakanaDiphtongues, letterTab: kana.letterDiphtongues))
        sections.append(KanaDatasType.init(title: NSLocalizedString("Derivatives + Diphthongs", comment: ""), kanaTab: kana.katakanaDerivesDiphtongues, letterTab: kana.letterDerivesDiphtongues))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].kanaTab.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(cellType: KanaCell.self)
        let cell: KanaCell = tableView.dequeueReusableCell(for: indexPath)
        
        for index in 0...cell.kanaLabel.count - 1 {
            cell.kanaLabel[index].text = sections[indexPath.section].kanaTab[indexPath.row][index]
            cell.letterLabel[index].text = sections[indexPath.section].letterTab[indexPath.row][index]
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 0.5)
        cell.selectedBackgroundView = backgroundView

        cell.backgroundColor = .clear
        
        return cell
    }
}

//
//  HiraganaViewController.swift
//  NihonGoal
//
//  Created by kuroro on 04/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Hero
import Reusable

class HiraganaViewController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    private var sections = [KanaDatasType]()
    private let kana = Kana()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSections()
        backgroundView.setGradient(firstColor: #colorLiteral(red: 0.6382738352, green: 0.6152765751, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), rounded: false)
        tableView.backgroundColor = .clear
    }
    
    // MARK: IBActions
    @IBAction func unwindToHiragana(segue:UIStoryboardSegue) {
    }
}

// MARK: TableView gestion
extension HiraganaViewController: UITableViewDataSource, UITableViewDelegate {
    func setSections() {
        sections.append(KanaDatasType.init(title: NSLocalizedString("Fundamental characters", comment: ""), kanaTab: kana.hiraganaTab, letterTab: kana.letterTab))
        sections.append(KanaDatasType.init(title: NSLocalizedString("Derivatives", comment: ""), kanaTab: kana.hiraganaDerives, letterTab: kana.letterDerives))
        sections.append(KanaDatasType.init(title: NSLocalizedString("Diphthongs", comment: ""), kanaTab: kana.hiraganaDiphtongues, letterTab: kana.letterDiphtongues))
        sections.append(KanaDatasType.init(title: NSLocalizedString("Derivatives + Diphthongs", comment: ""), kanaTab: kana.hiraganaDerivesDiphtongues, letterTab: kana.letterDerivesDiphtongues))
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
        
        cell.backgroundColor = .clear
        
        return cell
    }
}

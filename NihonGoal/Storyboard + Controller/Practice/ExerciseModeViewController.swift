//
//  ExerciseModeViewController.swift
//  NihonGoal
//
//  Created by kuroro on 08/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseAuth

enum ExerciseMode {
    case zen, fast
}

class ExerciseModeViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionIndicatorLabel: UILabel!
    @IBOutlet var answerButtons: [CustomPracticeButton]!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var bigCounter: UILabel!
    @IBOutlet weak var gameCounter: UILabel!
    
    // MARK: Properties
    private lazy var loadingController = LoadingViewController()
    private let userController = UserController()
    private let kana = Kana()

    private var questionsTab = [String]()
    private var answersTab = [String]()
    private var fullQuestionsTab = [String]()

    private var questionCounter = -1
    private var score = 0
    // Random number properties
    private var randomButtonIndex = Int()
    private var randomIndex = Int()
    // Timer properties
    private var timer = Timer()
    private var time: Double = 0
    private var averageTime = Double()
    // Properties values init by fetching database
    private var hiraganaUserTab = [String]()
    private var katakanaUserTab = [String]()
    private var newTabToSend = [String]()
    // Properties values received from segue
    var kanaTab = [[String]]()
    var letterTab = [[String]]()
    var fullAnswersTab = [String]()
    var modeIndicator: ExerciseMode = .zen
    var direction: Direction = .kanaToLetter
    var typeOfKana: TypeOfKana = .hiragana
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchHiraganaAndKatakanaTab()
        setQuestionsAndAnswersTab(kanaTab: kanaTab, letterTab: letterTab, direction: direction)
        setGameMode(gameMode: modeIndicator)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        timer.invalidate()
    }
    
    // MARK: Methods
    
    // MARK: --------------------------------- Handle kanas progression ---------------------------------
    // Fetch user hiraganaTab and KatakanaTab from database
    private func fetchHiraganaAndKatakanaTab() {
        add(loadingController)
        userController.getUser { (result) in
            self.loadingController.remove()
            DispatchQueue.main.async {
                switch result {
                case .success(let userDatas):
                    self.hiraganaUserTab = userDatas.hiraganaTab
                    self.katakanaUserTab = userDatas.katakanTab
                    // if the exercise is about hiragana newTabToSend will take hiraganaTab value else katakanaTab
                    // newTabToSend as indicated by its name, will be the new tab wich will replace the previous one, when the exercise is over
                    switch self.typeOfKana {
                    case .hiragana:
                        self.newTabToSend = self.hiraganaUserTab
                    case .katakana:
                        self.newTabToSend = self.katakanaUserTab
                    }
                case .failure(let error):
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                }
            }
        }
    }

    // Function triggered when the user has the correct answer
    private func addNewSucceedKanaToTabs(typeOfKana: TypeOfKana, kana: String) {
        // If newTabToSend == 0, add the kana to it, otherwise go on
        guard newTabToSend.count != 0 else {
            newTabToSend.append(kana)
            return
        }

        // Sometimes database will give by itself a first value equal to "" for an empty array
        // So with this "guard", if the first value is "", remove the whole tab and add the kana, otherwise, once again, go on
        guard newTabToSend.first != "" else {
            newTabToSend.removeAll()
            newTabToSend.append(kana)
            return
        }

        // Check in the tab if the "succeed kana" does not match with a tab's value. If it does, it means the user has already succeeded on that kana, so we don't add it to the tab.
        for index in 0...newTabToSend.count - 1 where newTabToSend[index] == kana {
            return
        }

        newTabToSend.append(kana)
    }

    // This function replace the previous tab by the new one (newTabToSend)
    // Function triggered when the exercise is over
    private func updateNewTabToDataBase(typeOfKana: TypeOfKana) {
        add(loadingController)

        var typeOfTab = String()

        switch typeOfKana {
        case .hiragana:
            typeOfTab = "hiraganaTab"
        case .katakana:
            typeOfTab = "katakanaTab"
        }

        userController.updateSpecificData(collection: "Users", document: Auth.auth().currentUser?.uid ?? "", field: typeOfTab, newValue: newTabToSend) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentAlert(message: AlertMessage().programError, title: "Oups")
                } else {
                    self.loadingController.remove()
                    self.performSegue(withIdentifier: "segueToResult", sender: self)
                }
            }
        }
    }

    // MARK: --------------------------------- Set game methods ---------------------------------
    private func setQuestionsAndAnswersTab(kanaTab: [[String]], letterTab: [[String]], direction: Direction) {
        // Initialize the questions and answer tabs with, with kana or letter (depending on .direction)
        switch direction {
        case .kanaToLetter:
            questionsTab = kana.setTab(tab: kanaTab)
            answersTab = kana.setTab(tab: letterTab)
        case .letterToKana:
            questionsTab = kana.setTab(tab: letterTab)
            answersTab = kana.setTab(tab: kanaTab)
        }
        // totalQuestions tab is initilized to keep all questions
        fullQuestionsTab = questionsTab
    }

    private func setGameMode(gameMode: ExerciseMode) {
        switch gameMode {
        case .zen:
            updateUIAndLaunchGame(mode: 0)
        case .fast:
            launchBigCounter()
        }
    }

    // MARK: --------------------------------- Start game method ---------------------------------
    private func updateUIAndLaunchGame(mode: Int) {
        switch mode {
            // If .zen mode, and launch the game normally.
        case 0:
            timer.invalidate()
            self.time = 0
            
            bigCounter.isHidden = true
            questionLabel.isHidden = false
            questionIndicatorLabel.isHidden = false
            scoreLabel.isHidden = false
            answerButtons.forEach({ $0.isHidden = false })
            
            upScoreAndQuestionCounter(UIButton())
        case 1:
            // If .fast mode, unhide gameCounter, lauch it and launch the game.
            timer.invalidate()
            self.time = 0

            bigCounter.isHidden = true
            gameCounter.isHidden = false
            questionLabel.isHidden = false
            questionIndicatorLabel.isHidden = false
            scoreLabel.isHidden = false
            answerButtons.forEach({ $0.isHidden = false })

            upScoreAndQuestionCounter(UIButton())
            launchGameCounter()
        default:
            presentAlert(message: AlertMessage().programError, title: "Oups !")
        }
    }

    // MARK: --------------------------------- Launch timer/counter methods ---------------------------------
    // Function to launch the Big (first) counter.
    private func launchBigCounter() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeDidEnded), userInfo: nil, repeats: true)

        animateCounter()
    }

    @objc private func timeDidEnded() {
        time += 1
        animateCounter()
        
        if time == 4 {
            updateUIAndLaunchGame(mode: 1)
        } else {
            bigCounter.text = String(format: "%.f", time)
        }
    }

    // Function to launch the game counter.
    private func launchGameCounter() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(gameTimeDidEnded), userInfo: nil, repeats: true)
    }

    @objc private func gameTimeDidEnded() {
        time += 0.01
        let convertedTime = String(format: "%.2f", time)
        gameCounter.text = convertedTime

        // Every 3seconds relaunch a new question by the "upScoreAndQuestionCounter"
        // That means the user took too long to respond.
        if convertedTime == "3.00" {
            averageTime += time
            self.time = 0
            upScoreAndQuestionCounter(UIButton())
        }
    }

    // MARK: --------------------------------- Game intelligence methods ---------------------------------
    private func upScoreAndQuestionCounter(_ button: UIButton) {
        // Up questionCounter by one to keep the user informed
        questionCounter += 1
        questionIndicatorLabel.text = "\(questionCounter) / \(fullQuestionsTab.count)"
        // ---------------------------------------------------------------------------------
        // To understand the following part you have to know that:
        // 1. When the user taps one of the three buttons, this button is passed ad parameter of this function
        // 2. In the "loadRound()" function we initialize a random number "randomButtonIndex". This number is used to choose randomly one of the three buttons.
        // 3. If the button (passed as parameter) has its title equal to the answerButtons[randomButtonIndex].title, the user answered correctly
        if button.titleLabel?.text == answerButtons?[randomButtonIndex].titleLabel?.text {
            // score increases by one
            score += 1
            scoreLabel.text = "Score: \(score)"
            // We want to add the "kana" to the "newTabToSend" not the "letter", so depending on the direction, we add the the right button.title or the right question.text.
            if direction == .kanaToLetter {
                addNewSucceedKanaToTabs(typeOfKana: typeOfKana, kana: questionLabel.text ?? "")
            } else {
                addNewSucceedKanaToTabs(typeOfKana: typeOfKana, kana: button.titleLabel?.text ?? "")
            }
                animateButton(button: button, color: #colorLiteral(red: 0, green: 1, blue: 0, alpha: 0.7986140839))
        } else {
            animateButton(button: button, color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.8009952911))
        }
    }
    
    private func loadRound() {
        // Init a property transitionTab equal to fullAnswersTab
        // This tab is used to display the three answers available for each round
        var transitionTab = fullAnswersTab

        // When the game is over, add the newTabToSend to the database
        guard questionsTab.count != 0 else {
            updateNewTabToDataBase(typeOfKana: typeOfKana)
            return
        }
        
        // Init random index to choose randomly a letter/kana in the kanaTab/letterTab
        randomIndex = kana.pullOutRandomNumber(from: 0, to: questionsTab.count - 1)
        questionLabel.text = questionsTab[randomIndex]

        // Init random button index to add randomly the right kana/letter to a one of the three buttons's title
        randomButtonIndex = kana.pullOutRandomNumber(from: 0, to: 2)
        answerButtons?[randomButtonIndex].setTitle(answersTab[randomIndex], for: .normal)
        
        // Delete this choosen kana/letter from its tab
        questionsTab = kana.deleteValueFromTab(tab: questionsTab, index: randomIndex)
        answersTab = kana.deleteValueFromTab(tab: answersTab, index: randomIndex)
        // Delete it too from the transitionTab
        transitionTab = kana.deleteValueFromTab(tab: transitionTab, index: randomIndex)
        // By this way, it won't be added to one of the two remaining buttons's title
        
        for index in 0...answerButtons.count - 1 where index != randomButtonIndex {
            // Set a new random index now based on the transitionTab
            let newRandomIndex = kana.pullOutRandomNumber(from: 0, to: transitionTab.count - 1)
            // Set button title equal to transitionTab[newRandomIndex]'s value
            answerButtons[index].setTitle(transitionTab[newRandomIndex], for: .normal)
            // Delete the transitionTab[newRandomIndex]'s value from transitionTab
            // By this way, we're sure that both button's titles left won't be same
            transitionTab = kana.deleteValueFromTab(tab: transitionTab, index: newRandomIndex)
        }
    }
    
    // MARK: IBActions
    @IBAction func didTapAnswerButton(_ sender: Any) {
        guard let button = sender as? UIButton else {
            presentAlert(message: AlertMessage().programError, title: "Oups !")
            return
        }

        averageTime += time
        time = 0
        upScoreAndQuestionCounter(button)
    }
}

// MARK: Prepare segue gestion
extension ExerciseModeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToResult" {
            guard let successVC = segue.destination as? ResultViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successVC.totalQuestion = fullQuestionsTab.count
            successVC.modeIndicator = modeIndicator
            successVC.averageTime = (averageTime / Double(fullQuestionsTab.count))
            successVC.score = score
        }
    }
}

// MARK: Animation gestion
extension ExerciseModeViewController {
    func animateCounter() {
        self.bigCounter.layer.opacity = 1

        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .autoreverse,
                       animations: { [] in
                       self.bigCounter.layer.opacity = 0
        })
    }
    
    func animateButton(button: UIButton, color: UIColor) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       animations: { [] in
                        button.backgroundColor = color
                        button.backgroundColor = #colorLiteral(red: 0.9745646119, green: 0.9697194695, blue: 1, alpha: 0.5)
                        self.loadRound()
        })
    }
}

//
//  GamePresenter.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit

final class GamePresenter {

    weak var view: GameViewController?
    weak var output: GameModuleOutput?
    var state: GameState

    init(state: GameState) {
        self.state = state
    }

    private func randomString(_ answer: String) -> String {
        var randomLetters = ""
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let length = state.numberLetterButtons - answer.count
        for _ in 0 ..<  length {
            let randomNum = Int.random(in: 0..<letters.count)
            let randomIndex = letters.index(letters.startIndex, offsetBy: randomNum)
            let newCharacter = letters[randomIndex]
            randomLetters.append(newCharacter)
        }
        for char in answer {
            let randomNum = Int.random(in: 0..<randomLetters.count)
            let randomIndex = letters.index(letters.startIndex, offsetBy: randomNum)
            randomLetters.insert(char, at: randomIndex)
        }
        return randomLetters
    }
}

extension GamePresenter: GameViewOutput {
    func changeLevel() {
        if state.currentLevelIndex == 2 {
            state.currentLevelIndex = 0
            showMenuScreen()
        }
        else {
            state.currentLevelIndex += 1
        }
        state.currentAnswer = ""
        view?.letters = randomString(state.levels[state.currentLevelIndex].answer)
        view?.letters += "?"
        view?.answerCount = state.levels[state.currentLevelIndex].answer.count
        view?.update(level: state.levels[state.currentLevelIndex])
    }

    func getHelpLetter() -> String {
        var index: Int
        if state.levels[state.currentLevelIndex].answer.count == state.currentAnswer.count {
            index = state.currentAnswer.count - 1
        }
        else {
            index = state.currentAnswer.count
        }
        var letter: String = state.levels[state.currentLevelIndex].answer.getSymbol(byIndex: index)
        for number in 0..<state.currentAnswer.count {
            if state.levels[state.currentLevelIndex].answer.getSymbol(byIndex: number) != state.currentAnswer.getSymbol(byIndex: number) {
                letter = state.levels[state.currentLevelIndex].answer.getSymbol(byIndex: number)
                break
            }
        }
        return letter
    }

    func removeLetter() {
        guard state.currentAnswer.count != 0 else {
            return
        }
        state.currentAnswer.removeLast()
        view?.answerButtons[state.currentAnswer.count].setTitle("", for: .normal)
        let image = UIImage(named: "inputButton")
        view?.answerButtons[state.currentAnswer.count].setBackgroundImage(image, for: .disabled)
    }

    func moveLetter(letter: String) -> Bool {
        guard state.currentAnswer.count != state.levels[state.currentLevelIndex].answer.count else {
            return false
        }
        view?.answerButtons[state.currentAnswer.count].setTitle(letter, for: .normal)
        let image = UIImage(named: "letterButton")
        view?.answerButtons[state.currentAnswer.count].setBackgroundImage(image, for: .disabled)
        state.currentAnswer += letter
        if state.currentAnswer == state.levels[state.currentLevelIndex].answer {
            view?.popViewHeaderLabel.text = "Level Completed"
            view?.popViewLabel.text = state.levels[state.currentLevelIndex].answer
            view?.popViewButton.removeTarget(view, action: #selector(view?.hidePopView), for: .touchUpInside)
            view?.popViewButton.addTarget(view, action: #selector(view?.tapNextLevelButton), for: .touchUpInside)
            if state.currentLevelIndex == 2 {
                view?.popViewButton.setTitle("Back to Menu", for: .normal)
            }
            else {
                view?.popViewButton.setTitle("Next level", for: .normal)
            }
            view?.popView.isHidden = false
            view?.popViewTextLabel.isHidden = false
            view?.coins += 100
            view?.coinsLabel.text = String(view?.coins ?? 0)
        }
        return true
    }

    func viewDidLoad() {
        view?.letters = randomString(state.levels[state.currentLevelIndex].answer)
        view?.letters += "?"
        view?.answerCount = state.levels[state.currentLevelIndex].answer.count
        view?.update(level: state.levels[0])
    }

    func showMenuScreen() {
        output?.gameModuleMenuModuleShow(self)
    }
}

extension GamePresenter: GameModuleInput {
}

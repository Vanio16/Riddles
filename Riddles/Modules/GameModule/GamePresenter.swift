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
    func getHelpLetter() -> String {
        var letter: String = state.answer.getSymbol(byIndex: state.currentAnswer.count)
        for number in 0..<state.currentAnswer.count {
            if state.answer.getSymbol(byIndex: number) != state.currentAnswer.getSymbol(byIndex: number) {
                letter = state.answer.getSymbol(byIndex: number)
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
        guard state.currentAnswer.count != state.answer.count else {
            return false
        }
        view?.answerButtons[state.currentAnswer.count].setTitle(letter, for: .normal)
        let image = UIImage(named: "letterButton")
        view?.answerButtons[state.currentAnswer.count].setBackgroundImage(image, for: .disabled)
        state.currentAnswer += letter
        return true
    }

    func viewDidLoad() {
        view?.letters = randomString(state.answer)
        view?.answerCount = state.answer.count
    }
    func showMenuScreen() {
        output?.gameModuleMenuModuleShow(self)
    }
}

extension GamePresenter: GameModuleInput {
}
extension String {
    func getSymbol(byIndex index: Int) -> String {
        String(self[self.index(self.startIndex, offsetBy: index)])
    }
}

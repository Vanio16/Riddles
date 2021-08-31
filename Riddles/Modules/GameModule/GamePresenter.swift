//
//  GamePresenter.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

final class GamePresenter {

    weak var view: GameViewController?
    weak var output: GameModuleOutput?
    init(state: GameState) {

    }
    private func randomString(_ answer: String) -> String {
        var randomLetters = ""
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let length = 14 - answer.count
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
    func viewDidLoad() {
        view?.letters = randomString("one")
    }
    func showMenuScreen() {
        output?.gameModuleMenuModuleShow(self)
    }
}

extension GamePresenter: GameModuleInput {
}

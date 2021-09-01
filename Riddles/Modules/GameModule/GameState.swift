//
//  GameState.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

final class GameState {
    var currentLevelIndex = 0
    var answer = "two"
    var currentAnswer = ""
    var task = "1 + 1"
    let numberLetterButtons = 14
    var levels: [Level]

    init(levels: [Level]) {
        self.levels = levels
    }
}

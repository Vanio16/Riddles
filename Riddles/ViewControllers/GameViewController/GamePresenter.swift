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
}

extension GamePresenter: GameViewOutput {
    func showMenuScreen() {
        
    }
    

}

extension GamePresenter: GameModuleInput {

}

//
//  GameModule.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

protocol GameModuleInput: AnyObject {

}

protocol GameModuleOutput: AnyObject {

}

final class GameModule {

    var input: GameModuleInput {
        return presenter
    }
    var output: GameModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: GameViewController
    private let presenter: GamePresenter

    init(state: GameState = .init()) {
        let presenter = GamePresenter(state: state)
        let viewController = GameViewController(output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}

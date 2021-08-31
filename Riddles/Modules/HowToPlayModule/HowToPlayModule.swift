//
//  HowToPlayModule.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

protocol HowToPlayModuleInput: AnyObject {

}

protocol HowToPlayModuleOutput: AnyObject {
    func howToPlayModuleMenuModuleShow(_ moduleInput: HowToPlayModuleInput)
}

final class HowToPlayModule {

    var input: HowToPlayModuleInput {
        return presenter
    }
    var output: HowToPlayModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: HowToPlayViewController
    private let presenter: HowToPlayPresenter

    init(state: HowToPlayState = .init()) {
        let presenter = HowToPlayPresenter(state: state)
        let viewController = HowToPlayViewController(output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}

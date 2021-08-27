//
//  NewCollectionModule.swift
//  City
//
//  Created by Ivan Zakharov on 23/8/21.
//

import Foundation

protocol MenuModuleInput: AnyObject {

}

protocol MenuModuleOutput: AnyObject {
    func showGameScreen()
}

final class MenuModule {

    var input: MenuModuleInput {
        return presenter
    }
    var output: MenuModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: MenuViewController
    private let presenter: MenuPresenter

    init(state: MenuState = .init()) {
        let presenter = MenuPresenter(state: state)
        let viewController = MenuViewController(output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}

//
//  StoreModule.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

protocol StoreModuleInput: AnyObject {

}

protocol StoreModuleOutput: AnyObject {
    func storeModuleMenuModuleShow(_ moduleInput: StoreModuleInput)
}

final class StoreModule {

    var input: StoreModuleInput {
        return presenter
    }
    var output: StoreModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: StoreViewController
    private let presenter: StorePresenter

    init(state: StoreState = .init()) {
        let presenter = StorePresenter(state: state)
        let viewController = StoreViewController(output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}

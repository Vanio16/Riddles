//
//  NewCollectionPresenter.swift
//  City
//
//  Created by Ivan Zakharov on 23/8/21.
//

import Foundation

final class MenuPresenter {

    weak var view: MenuViewController?
    weak var output: MenuModuleOutput? {
        didSet {

        }
    }
    init(state: MenuState) {

    }
}

extension MenuPresenter: MenuViewOutput {
    func showGameScreen() {
        output?.menuModuleGameModuleShow(self)
    }

    func showHowToPlayScreen() {
        output?.menuModuleHowToPlayModuleShow(self)
    }

    func showStoreScreen() {
        output?.menuModuleStoreModuleShow(self)
    }
}

extension MenuPresenter: MenuModuleInput {

}

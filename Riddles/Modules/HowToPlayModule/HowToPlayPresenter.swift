//
//  HowToPlayPresenter.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

final class HowToPlayPresenter {

    weak var view: HowToPlayViewController?
    weak var output: HowToPlayModuleOutput?
    init(state: HowToPlayState) {

    }
}

extension HowToPlayPresenter: HowToPlayViewOutput {
    func showMenuScreen() {
        output?.howToPlayModuleMenuModuleShow(self)
    }
}

extension HowToPlayPresenter: HowToPlayModuleInput {

}

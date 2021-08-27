//
//  NewCollectionPresenter.swift
//  City
//
//  Created by Ivan Zakharov on 23/8/21.
//

import Foundation

final class MenuPresenter {

    weak var view: MenuViewController?
    weak var output: MenuModuleOutput?
    init(state: MenuState) {

    }
}

extension MenuPresenter: MenuViewOutput {

}

extension MenuPresenter: MenuModuleInput {

}

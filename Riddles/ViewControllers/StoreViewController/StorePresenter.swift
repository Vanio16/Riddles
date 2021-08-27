//
//  StorePresenter.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation

final class StorePresenter {

    weak var view: StoreViewController?
    weak var output: StoreModuleOutput?
    init(state: StoreState) {

    }
}

extension StorePresenter: StoreViewOutput {

}

extension StorePresenter: StoreModuleInput {

}

//
//  MainCoordinator.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit

final class MainCoordinator: MenuModuleOutput, GameModuleOutput, HowToPlayModuleOutput, StoreModuleOutput {

    let window: UIWindow
    var navigationController: UINavigationController
    let menuModule = MenuModule()
    var gameModule: GameModule?
    let howToPlayModule = HowToPlayModule()
    let storeModule = StoreModule()
    let levelService = LevelService()

    init(window: UIWindow) {
        self.window = window
        navigationController = .init(rootViewController: menuModule.viewController)
        navigationController.navigationBar.isHidden = true
    }

    func start() {
        menuModule.output = self
        howToPlayModule.output = self
        storeModule.output = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func menuModuleGameModuleShow(_ moduleInput: MenuModuleInput) {
        guard let levels = levelService.loadJson(filename: "Levels") else {
            return
        }
        let gameModule = GameModule(state: .init(levels: levels))
        self.gameModule = gameModule
        gameModule.output = self
        navigationController.pushViewController(gameModule.viewController, animated: true)
    }

    func menuModuleHowToPlayModuleShow(_ moduleInput: MenuModuleInput) {
        navigationController.pushViewController(howToPlayModule.viewController, animated: true)
    }

    func menuModuleStoreModuleShow(_ moduleInput: MenuModuleInput) {
        navigationController.pushViewController(storeModule.viewController, animated: true)
    }

    func gameModuleMenuModuleShow(_ moduleInput: GameModuleInput) {
        navigationController.popViewController(animated: true)
    }

    func howToPlayModuleMenuModuleShow(_ moduleInput: HowToPlayModuleInput) {
        navigationController.popViewController(animated: true)
    }

    func storeModuleMenuModuleShow(_ moduleInput: StoreModuleInput) {
        navigationController.popViewController(animated: true)
    }
}

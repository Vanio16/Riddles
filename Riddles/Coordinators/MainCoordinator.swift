//
//  MainCoordinator.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit

final class MainCoordinator: MenuModuleOutput, GameModuleOutput, HowToPlayModuleOutput, StoreModuleOutput{
    let window: UIWindow
    var navigationController: UINavigationController
    let menuModule = MenuModule()
    let gameModule = GameModule()
    let howToPlayModule = HowToPlayModule()
    let storeModule = StoreModule()
    
    init(window: UIWindow) {
        self.window = window
        navigationController = .init(rootViewController: menuModule.viewController)
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        menuModule.output = self
        gameModule.output = self
        howToPlayModule.output = self
        storeModule.output = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showGameScreen() {
        navigationController.pushViewController(gameModule.viewController, animated: true)
    }
}

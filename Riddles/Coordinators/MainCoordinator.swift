//
//  MainCoordinator.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit

final class MainCoordinator: MenuModuleOutput {
    let window: UIWindow
    var navigationController: UINavigationController
    let menuModule = MenuModule()
    
    init(window: UIWindow) {
        self.window = window
        navigationController = .init(rootViewController: menuModule.viewController)
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        menuModule.output = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

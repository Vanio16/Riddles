//
//  NewCollectionViewController.swift
//  City
//
//  Created by Ivan Zakharov on 23/8/21.
//

import Foundation
import UIKit
import Framezilla

protocol MenuViewOutput {
}

final class MenuViewController: UIViewController {

    private struct Constants {
        static let insetBetweenItems: CGFloat = 16
        static let insetBetweenRows: CGFloat = 16
    }

    private let output: MenuViewOutput


    // MARK: - Subview


    // MARK: - Lifecycle

    init(output: MenuViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
    }
}

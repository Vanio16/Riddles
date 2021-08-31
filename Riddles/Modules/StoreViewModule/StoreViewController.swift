//
//  StoreViewController.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit
import Framezilla

protocol StoreViewOutput {
    func showMenuScreen()
}

final class StoreViewController: UIViewController {

    private struct Constants {
        static let headerImageHeight: CGFloat = 60
        static let backButtonInsetLeft: CGFloat = 10
        static let backButtonSize: CGSize = .init(width: 40, height: 40)
    }

    private let output: StoreViewOutput

// MARK: - Subviews

    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "bg")
        return image
    }()
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "header")
        return image
    }()
    private let backButton: UIButton = {
       let button = UIButton()
        let image = UIImage(named: "backButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showMenuScreen), for: .touchUpInside)
        return button
    }()
    private let temporaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Store Screen"
        label.textColor = .white
       return label
    }()

    // MARK: - Lifecycle

    init(output: StoreViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.add(backgroundImage, headerImage, backButton, temporaryLabel)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        backgroundImage.configureFrame { maker in
            maker.top()
                .right()
                .left()
                .bottom()
        }
        headerImage.configureFrame { maker in
            maker.top()
                .right()
                .left()
                .height(Constants.headerImageHeight + view.safeAreaInsets.top)
        }
        backButton.configureFrame { maker in
            maker.centerY(to: headerImage.nui_centerY, offset: -view.safeAreaInsets.top / 2)
                .size(Constants.backButtonSize)
                .left(to: view.nui_safeArea.left, inset: Constants.backButtonInsetLeft)
        }
        temporaryLabel.configureFrame { maker in
            maker.center().sizeToFit()
        }
    }

    @objc private func showMenuScreen() {
        output.showMenuScreen()
    }
}

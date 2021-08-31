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
    func showGameScreen()
    func showHowToPlayScreen()
    func showStoreScreen()
}

final class MenuViewController: UIViewController {

    private struct Constants {
        static let insetBetweenButtons: CGFloat = 16
        static let playButtonHeight: CGFloat = 60
        static let playButtonSidesInset: CGFloat = 45
        static let playButtonInsetTop: CGFloat = 200
        static let howToPlayButtonHeight: CGFloat = 60
        static let howToPlayButtonSidesInset: CGFloat = 45
        static let storeButtonHeight: CGFloat = 60
        static let storeButtonSidesInset: CGFloat = 45
    }

    private let output: MenuViewOutput

// MARK: - Subview

    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "bg")
        return image
    }()
    private let headerImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "header")
        return image
    }()
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Riddles"
        label.font = UIFont(name: "BotanicaRegular", size: 40)
        return label
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "playButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showGameScreen), for: .touchUpInside)
        return button
    }()
    private let howToPlayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "howtoplayButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showHowToPlayScreen), for: .touchUpInside)
        return button
    }()
    private let storeButton: UIButton = {
       let button = UIButton()
        let image = UIImage(named: "storeButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showStoreScreen), for: .touchUpInside)
        return button
    }()

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
        view.add(backgroundImage, headerImage, headerLabel, playButton, howToPlayButton, storeButton)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        backgroundImage.configureFrame { maker in
            maker.top()
                .bottom()
                .right()
                .left()
        }
        headerImage.configureFrame { maker in
            maker.top()
                .right()
                .left()
                .height(60 + view.safeAreaInsets.top)
        }
        headerLabel.configureFrame { maker in
            maker.top(to: view.nui_safeArea.top)
                .centerX()
                .sizeToFit()
        }
        playButton.configureFrame { maker in
            maker.centerX()
                .height(Constants.playButtonHeight)
                .top(to: headerImage.nui_bottom, inset: Constants.playButtonInsetTop)
                .right(inset: Constants.playButtonSidesInset)
                .left(inset: Constants.playButtonSidesInset)
        }
        howToPlayButton.configureFrame { maker in
            maker.centerX()
                .height(Constants.howToPlayButtonHeight)
                .top(to: playButton.nui_bottom, inset: Constants.insetBetweenButtons)
                .right(inset: Constants.howToPlayButtonSidesInset)
                .left(inset: Constants.howToPlayButtonSidesInset)
        }
        storeButton.configureFrame { maker in
            maker.centerX()
                .height(Constants.storeButtonHeight)
                .top(to: howToPlayButton.nui_bottom, inset: Constants.insetBetweenButtons)
                .right(inset: Constants.storeButtonSidesInset)
                .left(inset: Constants.storeButtonSidesInset)
        }
    }

    @objc private func showGameScreen() {
        output.showGameScreen()
    }

    @objc private func showHowToPlayScreen() {
        output.showHowToPlayScreen()
    }

    @objc private func showStoreScreen() {
        output.showStoreScreen()
    }
}

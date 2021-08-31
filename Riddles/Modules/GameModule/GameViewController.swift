//
//  GameViewController.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit
import Framezilla

protocol GameViewOutput {
    func showMenuScreen()
    func viewDidLoad()
    func moveLetter(letter: String) -> Bool
    func removeLetter()
}

final class GameViewController: UIViewController {

    private struct Constants {
        static let headerImageHeight: CGFloat = 60
        static let backButtonInsetLeft: CGFloat = 10
        static let backButtonSize: CGSize = .init(width: 40, height: 40)
        static let backgroundCoinsImageSize: CGSize = .init(width: 80, height: 40)
        static let backgroundCoinsImageInsetRight: CGFloat = 10
        static let backgroundAnswerImageHeight: CGFloat = 90
        static let backgroundAnswerImageInsetBot: CGFloat = 40
        static let letterButtonsSize: CGSize = .init(width: 36, height: 36)
        static let letterButtonsInsetLeft: CGFloat = 10
        static let letterButtonsInsetBot: CGFloat = 10
        static let answerButtonsInsetBetweenButtons: CGFloat = 10
        static let answerButtonsSize: CGSize = .init(width: 40, height: 40)
    }
    private var bottomLetterButtons: [UIButton] = []
    private var topLetterButtons: [UIButton] = []
    private var hiddenButtons: [UIButton] = []
    var answerButtons: [UIButton] = []
    private let output: GameViewOutput
    var letters = ""
    var answerCount = 0

// MARK: - Subviews

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
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "backButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showMenuScreen), for: .touchUpInside)
        return button
    }()
    private let levelNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Level 1"
        label.font = UIFont(name: "BotanicaRegular", size: 40)
        return label
    }()
    private let backgroundCoinsImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "coinsButton")
        return image
    }()
    private let coinsLabel: UILabel = {
        let label = UILabel()
        label.text = "22"
        label.font = UIFont(name: "Oswald Regular", size: 20)
        return label
    }()
    private let backgroundAnswerImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "bgSolution")
        return image
    }()
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "1 + 1"
        label.font = UIFont(name: "Oswald Regular", size: 50)
        label.textColor = .white
        return label
    }()
    private let returnLetterButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "returnButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tapQuestionButton), for: .touchUpInside)
        return button
    }()
    private let answerView = UIView()

// MARK: - Lifecycle

    init(output: GameViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        letters += "?"
        view.add(backgroundImage,
                 headerImage,
                 backButton,
                 levelNumberLabel,
                 backgroundCoinsImage,
                 coinsLabel,
                 backgroundAnswerImage,
                 taskLabel,
                 returnLetterButton,
                 answerView)
        createLetterButtons()
        for _ in 0..<answerCount {
            let button = UIButton()
            let image = UIImage(named: "inputButton")
            button.setBackgroundImage(image, for: .disabled)
            button.setTitleColor(.black, for: .disabled)
            button.isEnabled = false
            answerView.add(button)
            answerButtons.append(button)
        }
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
            maker.centerY(to: headerImage.nui_centerY, offset: 0 - view.safeAreaInsets.top / 2)
                .size(Constants.backButtonSize)
                .left(to: view.nui_safeArea.left, inset: Constants.backButtonInsetLeft)
        }
        levelNumberLabel.configureFrame { maker in
            maker.centerY(to: headerImage.nui_centerY, offset: 0 - view.safeAreaInsets.top / 2)
                .centerX()
                .sizeToFit()
        }
        backgroundCoinsImage.configureFrame { maker in
            maker.centerY(to: headerImage.nui_centerY, offset: 0 - view.safeAreaInsets.top / 2)
                .right(to: view.nui_safeArea.right, inset: Constants.backgroundCoinsImageInsetRight)
                .size(Constants.backgroundCoinsImageSize)
        }
        coinsLabel.configureFrame { maker in
            maker.centerY(to: backgroundCoinsImage.nui_centerY)
                .left(to: backgroundCoinsImage.nui_left, inset: 5)
                .sizeToFit()
        }
        taskLabel.configureFrame { maker in
            maker.center().sizeToFit()
        }
        layoutLetterButtons()
        layoutAnswerField()
    }

    private func layoutLetterButtons() {
        for (number, button) in bottomLetterButtons.enumerated() {
            button.configureFrame { maker in
                maker.bottom(to: view.nui_safeArea.bottom, inset: Constants.letterButtonsInsetBot)
                    .size(Constants.letterButtonsSize)
                let inset = (view.frame.width - Constants.letterButtonsSize.width * 8 - Constants.letterButtonsInsetLeft * 2) / 7
                let insetLeft = Constants.letterButtonsInsetLeft +
                    Constants.letterButtonsSize.width * CGFloat(number) + inset * CGFloat(number)
                if number  == 0 {
                    maker.left(to: view.nui_safeArea.left, inset: Constants.letterButtonsInsetLeft)
                }
                else {
                    maker.left(to: view.nui_safeArea.left, inset: insetLeft)
                }
            }
        }
        for (number, button) in topLetterButtons.enumerated() {
            button.configureFrame { maker in
                maker.bottom(to: bottomLetterButtons[0].nui_top, inset: Constants.letterButtonsInsetBot)
                    .size(Constants.letterButtonsSize)
                let inset = (view.frame.width - Constants.letterButtonsSize.width * 8 - Constants.letterButtonsInsetLeft * 2) / 7
                let insetLeft = Constants.letterButtonsInsetLeft +
                    Constants.letterButtonsSize.width * CGFloat(number) + inset * CGFloat(number)
                if number  == 0 {
                    maker.left(to: view.nui_safeArea.left, inset: Constants.letterButtonsInsetLeft)
                }
                else {
                    maker.left(to: view.nui_safeArea.left, inset: insetLeft)
                }
            }
        }
        returnLetterButton.configureFrame { maker in
            maker.size(Constants.letterButtonsSize)
                .bottom(to: view.nui_safeArea.bottom, inset: Constants.letterButtonsInsetBot)
                .right(to: view.nui_safeArea.right, inset: Constants.backButtonInsetLeft)
        }
    }
    private func layoutAnswerField() {
        backgroundAnswerImage.configureFrame { maker in
            maker.right()
            maker.left()
            maker.height(Constants.backgroundAnswerImageHeight)
            maker.bottom(to: topLetterButtons[0].nui_top, inset: Constants.backgroundAnswerImageInsetBot)
        }

        answerView.configureFrame { maker in
            maker.centerY(to: backgroundAnswerImage.nui_centerY)
                .centerX(to: backgroundAnswerImage.nui_centerX)
                .height(Constants.answerButtonsSize.height)
                .width(Constants.answerButtonsSize.width * CGFloat(answerButtons.count) +
                        Constants.answerButtonsInsetBetweenButtons * CGFloat(answerButtons.count - 1))
        }
        for (number, button) in answerButtons.enumerated() {
            button.configureFrame { maker in
                maker.centerY()
                    .size(Constants.answerButtonsSize)
                    .top()
                    .bottom()
                    .left(inset: Constants.letterButtonsSize.width * CGFloat(number) +
                            Constants.answerButtonsInsetBetweenButtons * CGFloat(number))
            }
        }
    }

// MARK: - Actions

    private func createLetterButtons() {
        for _ in 0...6 {
            let button = UIButton()
            let image = UIImage(named: "letterButton")
            button.setBackgroundImage(image, for: .normal)
            button.setTitle(String(letters.first ?? "A"), for: .normal)
            letters.removeFirst()
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(tapLetterButton), for: .touchUpInside)
            view.add(button)
            bottomLetterButtons.append(button)
        }
        for number in 0...7 {
            let button = UIButton()
            let image = UIImage(named: "letterButton")
            button.setBackgroundImage(image, for: .normal)
            button.setTitle(String(letters.first ?? "A"), for: .normal)
            letters.removeFirst()
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(tapLetterButton), for: .touchUpInside)
            if number == 7 {
                // button.addTarget(self, action: #selector(tapQuestionButton), for: .touchUpInside)
            }
            view.add(button)
            topLetterButtons.append(button)
        }
    }
    @objc private func showMenuScreen() {
        output.showMenuScreen()
    }
    @objc private func tapLetterButton(sender: UIButton!) {
        guard let letter = sender.title(for: .normal) else {
            return
        }
        sender.isHidden = output.moveLetter(letter: letter)
        hiddenButtons.append(sender)

    }
    @objc private func tapQuestionButton() {
        guard !hiddenButtons.isEmpty else {
            return
        }
        output.removeLetter()
        hiddenButtons.last?.isHidden = false
        hiddenButtons.removeLast()
    }
}

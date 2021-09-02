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
    func moveLetter(letter: String) -> Int?
    func removeLetter()
    func getHelpLetter() -> String
    func changeLevel()
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
        static let letterButtonsSize: CGSize = .init(width: 40, height: 40)
        static let letterButtonsInsetLeft: CGFloat = 10
        static let letterButtonsInsetBot: CGFloat = 10
        static let answerButtonsInsetBetweenButtons: CGFloat = 10
        static let answerButtonsSize: CGSize = .init(width: 40, height: 40)
        static let helpHeaderLabelInsetTop: CGFloat = 10
        static let helpLabelInsetTop: CGFloat = 5
        static let helpButtonInsets: UIEdgeInsets = .init(top: 50, left: 10, bottom: 10, right: 10)
        static let helpButtonSize: CGSize = .init(width: 250, height: 60)
        static let helpViewHeight: CGFloat = 210
    }
    private var bottomLetterButtons: [UIButton] = []
    private var topLetterButtons: [UIButton] = []
    private var movedButtons: [LetterButton] = []
    var answerButtons: [UIButton] = []
    private let output: GameViewOutput
    var letters = ""
    var answerCount = 0
    var coins = 0

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

    let coinsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
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
        button.addTarget(self, action: #selector(tapUndoButton), for: .touchUpInside)
        return button
    }()

    private let answerView = UIView()

    let popView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 15
        return view
    }()

    let popViewHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Help"
        label.textColor = .white
        label.font = UIFont(name: "Oswald Regular", size: 20)
        label.textAlignment = .center
        return label
    }()

    let popViewLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.textColor = .white
        label.font = UIFont(name: "Oswald Regular", size: 20)
        label.textAlignment = .center
        return label
    }()

    let popViewButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "levelComplite")
        button.setTitle("OK", for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(hidePopView), for: .touchUpInside)
        return button
    }()

    let popViewTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Well done! You guessed the word and recieved 100 coins!"
        label.font = UIFont(name: "Oswald Regular", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let backgroundPopView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()

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
        popView.add(popViewLabel, popViewHeaderLabel, popViewButton, popViewTextLabel)
        backgroundPopView.add(popView)
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
        output.viewDidLoad()
        view.add(backgroundPopView)
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
                .width(50)
                .heightToFit()
        }

        taskLabel.configureFrame { maker in
            maker.center().sizeToFit()
        }
        layoutLetterButtons()
        layoutAnswerField()
        layoutPopField()
        bottomLetterButtons.forEach { bottomLetterButton in
            bottomLetterButton.superview?.bringSubviewToFront(bottomLetterButton)
        }
    }

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
            if number == 7 {
                button.addTarget(self, action: #selector(tapHelpButton), for: .touchUpInside)
            }
            else {
                button.addTarget(self, action: #selector(tapLetterButton), for: .touchUpInside)
            }
            view.add(button)
            topLetterButtons.append(button)
        }
    }

    private func createAnswerButtons() {
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

    private func layoutPopField() {
        backgroundPopView.configureFrame { maker in
            maker.top()
                .bottom()
                .left()
                .right()
        }

        let width = Constants.helpButtonSize.width + Constants.helpButtonInsets.left + Constants.helpButtonInsets.right
        popView.configureFrame { maker in
            maker.top(to: view.nui_bottom)
                .centerX()
                .size(width: width, height: Constants.helpViewHeight)
        }

        popViewHeaderLabel.configureFrame { maker in
            maker.centerX()
                .sizeToFit()
                .top(inset: Constants.helpHeaderLabelInsetTop)
                .left()
                .right()
        }

        popViewLabel.configureFrame { maker in
            maker.centerX()
                .sizeToFit()
                .top(to: popViewHeaderLabel.nui_bottom, inset: Constants.helpLabelInsetTop)
                .left()
                .right()
        }

        popViewTextLabel.configureFrame { maker in
            maker.centerX()
                .top(to: popViewLabel.nui_bottom, inset: 5)
                .left()
                .right()
                .heightToFit()
        }

        popViewButton.configureFrame { maker in
            maker.size(Constants.helpButtonSize)
                .bottom(inset: Constants.helpButtonInsets.bottom)
                .right(inset: Constants.helpButtonInsets.right)
                .left(inset: Constants.helpButtonInsets.left)
        }
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

    @objc private func showMenuScreen() {
        output.showMenuScreen()
    }

    class LetterButton {
        var button: UIButton
        var oldOrigin: CGPoint

        init(button: UIButton, oldOrigin: CGPoint) {
            self.button = button
            self.oldOrigin = oldOrigin
        }
    }

    @objc private func tapLetterButton(sender: UIButton!) {
        guard let letter = sender.title(for: .normal), movedButtons.count != answerCount else {
            return
        }
        if let index = output.moveLetter(letter: letter) {
            let button = LetterButton(button: sender, oldOrigin: sender.frame.origin)
            movedButtons.append(button)
            UIView.animate(withDuration: 1.0, animations: {
                sender.configureFrame { maker in
                    maker.top(to: self.answerView.nui_top)
                        .left(to: self.answerButtons[index].nui_left)
                }
            })
        }
        else {
        }
    }

    @objc private func tapUndoButton() {
        guard !movedButtons.isEmpty else {
            return
        }
        output.removeLetter()
        UIView.animate(withDuration: 1.0, animations: {
            self.movedButtons.last?.button.frame.origin = self.movedButtons.last?.oldOrigin ?? CGPoint(x: 0, y: 0)
        })
        movedButtons.removeLast()
    }

    @objc private func tapHelpButton() {
        backgroundPopView.isHidden = false
        popViewLabel.text = output.getHelpLetter()
        UIView.animate(withDuration: 1.0, animations: {
            self.popView.configureFrame { maker in
                maker.center()
            }
            self.backgroundPopView.alpha = 1
        })
    }

    @objc func hidePopView() {
        UIView.animate(withDuration: 1.0, animations: {
            self.popView.configureFrame { maker in
                maker.top(to: self.view.nui_bottom)
                    .centerX()
                self.backgroundPopView.alpha = 0
            }
        })
    }

    @objc func tapNextLevelButton() {
        output.changeLevel()
    }

    func update(level: Level) {
        bottomLetterButtons.forEach { bottomLetterButton in
            bottomLetterButton.removeFromSuperview()
        }
        bottomLetterButtons = []
        topLetterButtons.forEach { topLetterButton in
            topLetterButton.removeFromSuperview()
        }
        topLetterButtons = []
        answerButtons.forEach { answerButton in
            answerButton.removeFromSuperview()
        }
        answerButtons = []
        movedButtons = []
        createLetterButtons()
        layoutLetterButtons()
        createAnswerButtons()
        layoutAnswerField()
        backgroundPopView.removeFromSuperview()
        popViewButton.removeTarget(self, action: #selector(tapNextLevelButton), for: .touchUpInside)
        popViewButton.addTarget(self, action: #selector(hidePopView), for: .touchUpInside)
        popViewButton.setTitle("OK", for: .normal)
        popViewHeaderLabel.text = "Help"
        popViewTextLabel.isHidden = true
        view.add(backgroundPopView)
        backgroundPopView.isHidden = true
        levelNumberLabel.text = level.name
        taskLabel.text = level.task
    }
}

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
}

final class StoreViewController: UIViewController {

    private struct Constants {
    }

    private let output: StoreViewOutput

// MARK: - Subview

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
        view.add(backgroundImage, headerImage)
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
    }
}

//
//  UIView+Sugar.swift
//  Riddles
//
//  Created by Ivan Zakharov on 27/8/21.
//

import Foundation
import UIKit

extension UIView {
    func add(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}

//
//  String+Index.swift
//  Riddles
//
//  Created by Ivan Zakharov on 1/9/21.
//

import Foundation

extension String {
    func getSymbol(byIndex index: Int) -> String {
        String(self[self.index(self.startIndex, offsetBy: index)])
    }
}

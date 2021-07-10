//
//  Formatter.swift
//  budget
//
//  Created by wov on 2021/7/10.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

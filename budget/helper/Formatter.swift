//
//  Formatter.swift
//  budget
//
//  Created by wov on 2021/7/10.
//

//import Foundation
import SwiftUI


//float 的格式优化
extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

//关闭键盘的优化
//extension View {
//    func endEditing(_ force: Bool) {
//        UIApplication.shared.keyWindow?.endEditing(force)
//    }
//}

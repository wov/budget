//
//  IncomeAndExpenses.swift
//  budget
//
//  Created by wov on 2021/6/27.
//

//import Foundation
import CloudKit

// 类型是支出还是收入
enum incomeType {
    case income
    case expenses
}

// 是否是固定支出/收入
enum computingInterval {
    case none
    case month
    case quarterly
    case year
}

struct IncomeAndExpenses:Identifiable{
    var id = UUID()
    var recordId: CKRecord.ID?
    var type: incomeType
    var interval: computingInterval
    var amount: Float //金额
    var defaultAmount: Float //默认金额
    var from: Date //开始的时间
    var end: Date //结束的时间
}

//
//  Period.swift
//  budget
//
//  Created by wov on 2021/7/1.
//

//import Foundation
import CloudKit

struct Period {
    var id = UUID()
    var recordID: CKRecord.ID?
    
    var date: Date
    var isInit: Bool = false
    
    var target: Float
    var surplus: Float
    
    
}

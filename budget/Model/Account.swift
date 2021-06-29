//
//  Account.swift
//  budget
//
//  Created by wov on 2021/6/27.
//

import Foundation
import CloudKit

struct  Account:Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    
    var name: String
    var description: String
    
    
}

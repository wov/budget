//
//  Configure.swift
//  budget
//
//  Created by wov on 2021/7/18.
//

import Foundation

final class Configure: ObservableObject {
    @Published var currentDate = getCurrentYearAndMonth()
}
 
func getCurrentYearAndMonth() -> (year:String,month:String){
    let date = Date()
    let yearformat = DateFormatter()
    yearformat.dateFormat = "yyyy"
    let currentyear = yearformat.string(from: date)

    let monthformat = DateFormatter()
    monthformat.dateFormat = "MM"
    let currentmonth = monthformat.string(from: date)
    
    return(currentyear,currentmonth)
}

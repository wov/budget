//
//  PeriodList.swift
//  budget
//
//  Created by wov on 2021/7/18.
//

import SwiftUI

struct PeriodList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Period.entity(),
        sortDescriptors: [],
        animation: .default
    ) var periods: FetchedResults<Period>
    
    
    
    
    
    
    
    
    
    
    
    var body: some View {
        NavigationView {
            List{
                ForEach(self.periods){ period in
                    NavigationLink( destination : Home(period.id!)){
                        HStack{
                            Text( String("\(period.year!)-\(period.month!)")  )
                        }
                    }

                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("选择月份")
        }
    }
}

struct PeriodList_Previews: PreviewProvider {
    static var previews: some View {
        PeriodList()
    }
}

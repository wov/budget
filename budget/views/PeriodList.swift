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
    
    @FetchRequest(
        entity: CreatedIE.entity(),
        sortDescriptors: [],
        animation: .default
    ) var createdies: FetchedResults<CreatedIE>
    
    
    private func deletePeriods(offsets: IndexSet){
        for offset in offsets {
            let period = periods[offset]
            
            for ie in createdies{
                if(ie.period! == period.id!){
                    viewContext.delete(ie)
                }
            }
            
            viewContext.delete(period)
        }
        
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    
    var body: some View {
        NavigationView {
            List{
                ForEach(self.periods){ period in
                    NavigationLink( destination : Home(period.id!)){
                        HStack{
                            Text( String("\(period.year!)-\(period.month!)")  )
                        }
                    }
                }.onDelete(perform: deletePeriods)
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

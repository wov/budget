//
//  PeriodList.swift
//  budget
//
//  Created by wov on 2021/7/18.
//

import SwiftUI

struct PeriodList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var config: Configure

    @State private var showAddPeroid: Bool = false
    
    @FetchRequest(
        entity: Period.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Period.year, ascending: false),
                          NSSortDescriptor(keyPath: \Period.month, ascending: false)],
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
            if(self.periods.isEmpty){
                VStack{
                    Text("需要稍等片刻")
                    Text("等待iCloud自动同步")
                    Divider()
                    Text("如首次安装")
                    Text("点击")
                    Button("开始添加账期") {
                        self.showAddPeroid.toggle()
                    }
                }.padding()
            }else{
                List{
                    ForEach(self.periods){ period in
                        NavigationLink( destination : Home(period)){
                            HStack{
                                Text( String("\(period.year!)-\(period.month!)")  )
                            }
                        }
                    }.onDelete(perform: deletePeriods)
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("选择账期")
                .toolbar{
                    ToolbarItem() {
                        Button("添加账期") {
                            self.showAddPeroid.toggle()
                        }
                    }
                }
                
            }
        }
        .sheet(isPresented: $showAddPeroid, content: {
            addPeriod(showAddPeroid: self.$showAddPeroid, year: config.currentDate.year , month: config.currentDate.month)
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
}

struct PeriodList_Previews: PreviewProvider {
    static var previews: some View {
        PeriodList()
    }
}

//
//  AccountsRow.swift
//  budget
//
//  Created by wov on 2021/6/28.
//

import SwiftUI

struct AccountsRow: View {
    
    @EnvironmentObject var modelData: ModelData
    
    
    
    var body: some View {
        NavigationView {
            List{
                
                Section(header: Text("信用卡")){
                    
                    HStack{
                        VStack(alignment:.leading) {
                            Text("固定支出")
                                .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                            Text("iPhone分期")
                        }
                        Spacer()
                        Text("120")
                    }
                    
                    HStack{
                        VStack(alignment:.leading) {
                            Text("动态支出")
                                .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                            Text("交通费用")
                        }
                        Spacer()
                        Text("120")
                    }
                    
                }

                Section(header: Text("支付宝")){
                    
                    HStack{
                        VStack(alignment:.leading) {
                            Text("固定支出")
                                .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                            Text("iPhone分期")
                        }
                        Spacer()
                        Text("120")
                    }
                    
                    HStack{
                        VStack(alignment:.leading) {
                            Text("动态支出")
                                .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                            Text("交通费用")
                        }
                        Spacer()
                        Text("120")
                    }
                    
                }
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("2021-06")
        }
    }
}

struct AccountsRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountsRow()
//            .previewLayout(.fixed(width: 300, height: 200))
    }
}

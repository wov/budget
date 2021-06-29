//
//  Branch.swift
//  budget
//
//  Created by wov on 2021/6/29.
//

import SwiftUI

struct Branch: View {
    var body: some View {
        Path{ path in
            path.move(
                to: CGPoint(
                    x: 20.0,
                    y: 0.0
                )
            )
            
            path.addLine(
                to: CGPoint(
                    x: 20.0,
                    y: 40.0
                )
            )
            
            path.move(
                to: CGPoint(
                    x: 20.0,
                    y: 20.0
                )
            )
            path.addLine(
                to: CGPoint(
                    x: 40.0,
                    y: 20.0
                )
            )
           
        }
        .stroke(Color.black)
    }
}

struct Branch_Previews: PreviewProvider {
    static var previews: some View {
        Branch()
            .previewLayout(.fixed(width: 40, height: 40))

    }
}

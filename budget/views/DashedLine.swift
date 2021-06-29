//
//  DashedLine.swift
//  budget
//
//  Created by wov on 2021/6/29.
//

import SwiftUI

struct DashedLine: View {
    var body: some View {
        
        Path{ path in
            let width: CGFloat = 150.0
            let height: CGFloat = 5.0
            
            path.move(
                to: CGPoint(
                    x: 0.0,
                    y: height
                )
            )
            
            path.addLine(
                to: CGPoint(
                    x: width,
                    y: 5.0
                )
            )
           
        }
        .stroke(Color.black,style: StrokeStyle(
            lineWidth: 1, dash: [2]
        ))
        
    }
}

struct DashedLine_Previews: PreviewProvider {
    static var previews: some View {
        DashedLine()
            .previewLayout(.fixed(width: 300, height: 10))

    }
}

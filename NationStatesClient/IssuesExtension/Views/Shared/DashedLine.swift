//
//  DashedLine.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI

private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct DashedLine: View {
    var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
            .frame(height: 1)
            .foregroundColor(.gray)
            .opacity(0.5)
    }
}

struct DashedLine_Previews: PreviewProvider {
    static var previews: some View {
        DashedLine()
    }
}

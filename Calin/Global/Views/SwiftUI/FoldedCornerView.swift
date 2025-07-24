//
//  FoldedCornerView.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import SwiftUI

struct FoldedCornerShape: Shape {
    func path(in rect: CGRect) -> Path {
        let foldSize: CGFloat = 30
        var path = Path()
        path.move(to: CGPoint(x: 0, y: foldSize))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: foldSize, y: 0))
        path.closeSubpath()
        return path
    }
}

struct FoldedCorner: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 30))
        path.closeSubpath()
        return path
    }
}

struct FoldedCornerV: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 📄 노란 배경 + clipShape
            FoldedCornerShape()
                .fill(Color(red: 250/255, green: 237/255, blue: 125/255))
                .overlay(
                    FoldedCorner()
                        .fill(Color(red: 1.0, green: 1.0, blue: 0.8)) // 접힌 부분만 밝게
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(180))
                        .offset(x: 0, y: 0),
                    alignment: .topLeading
                )
        }
        .clipShape(FoldedCornerShape()) // 배경은 자르되 접힌 모서리는 위에서 오버레이
    }
}

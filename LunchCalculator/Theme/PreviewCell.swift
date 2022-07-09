//
//  PreviewCell.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/8/22.
//

import SwiftUI

/// A theme wrapper around a top level item. Edit one place, deploy everywhere.
///     - input: Expecting VStack or HStack or ZStack
struct PreviewCell<Content: View>: View {
    var input: () -> Content
    
    init(_ input: @escaping () -> Content) {
        self.input = input
    }
    
    var body: some View {
        input()
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
    }
}

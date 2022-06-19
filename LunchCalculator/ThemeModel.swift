//
//  ThemeModel.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct TextFieldHStack: View {
    var rs: LocalizedStringKey
    @Binding var ls: String
    
    var body: some View {
        HStack {
            Text(rs)
            TextField(rs, text: $ls)
        }
    }
}

struct DoubleFieldHStack: View {
    var rs: LocalizedStringKey
    @Binding var ls: Double
    
    var body: some View {
        HStack {
            Text(rs)
            TextField("Price", value: $ls, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
        }
    }
}


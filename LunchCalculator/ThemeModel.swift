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


struct KeyboardButton: View {
    enum NavigationOptions {
        case previous, next
    }

    
    let disabled: Bool
    let navigation: NavigationOptions
    let action: () -> Void
    
    var body: some View {
        
        var labelTitle:String {
            switch navigation {
            case .previous:
                return "Previous"
            case .next:
                return "Next"
            }
        }
        
        var labelSymbol:String {
            switch navigation {
            case .previous:
                return "arrow.up"
            case .next:
                return "arrow.down"
            }
        }
        
        return Button(action: {
            action()
        }, label: {
            Label(labelTitle, systemImage: labelSymbol)
        })
        .disabled(disabled)
    }
}


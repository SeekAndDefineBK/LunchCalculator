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
    
    var numberFormatter: NumberFormatter {
        let output = NumberFormatter()
        
        output.roundingMode = .down
        
        return output
    }
    
    var body: some View {
        HStack {
            Text(rs)
            TextField("Price", value: $ls, format: .number)
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

struct ReusableList<Content: View>: View {
    
    //MARK: input is expecting a Group that will be embedded into a list below
    var input: Content
    
    init(_ input: () -> Content) {
        self.input = input()
    }
    
    var body : some View {
        
        List {
            input
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}

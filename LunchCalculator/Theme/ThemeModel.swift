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
    @Environment(\.colorScheme) var colorScheme
    
    init(_ input: () -> Content) {
        self.input = input()
    }
    
    var body : some View {
        
        ZStack {
            if colorScheme == .dark {
                AngularGradient(
                    gradient: Gradient(
                        colors: [
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                            Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                            Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                            Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                        ]),
                        center: .center
                )
                    .edgesIgnoringSafeArea(.all)
                
                LinearGradient(
                    colors: [
                        .black.opacity(1),
                        .black.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                AngularGradient(
                    gradient: Gradient(
                        colors: [
                            Color(#colorLiteral(red: 0.848919332, green: 0.9708974957, blue: 1, alpha: 1)),
                            Color(#colorLiteral(red: 0.6831387281, green: 1, blue: 0.939740479, alpha: 1)),
                            Color(#colorLiteral(red: 0.848919332, green: 0.9708974957, blue: 1, alpha: 1)),
                            Color(#colorLiteral(red: 0.6831387281, green: 1, blue: 0.939740479, alpha: 1)),
                            Color(#colorLiteral(red: 0.848919332, green: 0.9708974957, blue: 1, alpha: 1)),
                            Color(#colorLiteral(red: 0.6831387281, green: 1, blue: 0.939740479, alpha: 1)),
                            Color(#colorLiteral(red: 0.848919332, green: 0.9708974957, blue: 1, alpha: 1))
                        ]),
                        center: .center
                )
                    .edgesIgnoringSafeArea(.all)
                
                LinearGradient(
                    colors: [
                        .white.opacity(1),
                        .white.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            List {
                input
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
        
    }
}

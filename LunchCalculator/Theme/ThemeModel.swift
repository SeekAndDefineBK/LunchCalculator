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
                            Color(#colorLiteral(red: 0.07516329736, green: 0.2165592611, blue: 0.1567329168, alpha: 1)),
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                            Color(#colorLiteral(red: 0.07516329736, green: 0.2165592611, blue: 0.1567329168, alpha: 1)),
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                            Color(#colorLiteral(red: 0.07516329736, green: 0.2165592611, blue: 0.1567329168, alpha: 1)),
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

struct FoodContainerCell: View {
    var food: FoodContainer
    
    var body: some View {
        PreviewCell {
            VStack(alignment: .leading) {
                HStack {
                    Text(food.displayName)
                        .font(.title3)
                        .bold()
                        .italic()
                    
                    Spacer()
                }
            }
        }
    }
}

struct FoodCell: View {
    var food: Food
    
    var body: some View {
        PreviewCell {
            VStack(alignment: .leading) {
                HStack {
                    Text(food.name)
                        .font(.title3)
                        .bold()
                        .italic()
                    
                    Spacer()
                    
                    Text("$\(food.totalWithExtrasDue, specifier: "%.2f")")
                        .bold()
                }
                
                Text("Purchased by \(food.personName) at \(food.restaurantName)")
            }
        }
    }
}

struct PersonCell: View {
    var person: Person
    
    var body: some View {
        PreviewCell {
            VStack(alignment: .leading) {
                HStack {
                    Text(person.name)
                        .font(.title3)
                        .bold()
                        .italic()
                    
                    Spacer()
                    
                    person.totalPaid
                }
                
                Text("\(person.lastOrderDescription)")
            }
        }
    }
}

struct ReceiptCell: View {
    var receipt: Receipt
    
    var body: some View {
        PreviewCell {
            HStack {
                VStack(alignment: .leading) {
                    Text(receipt.restaurantName)
                        .font(.title3)
                        .bold()
                        .italic()
                    
                        Text("on \(receipt.date.formatted(date: .numeric, time: .omitted))")
                        
                        HStack {
                            Text("with: \(receipt.allNames)")

                            Spacer()
                        }
                }
                
                Text("$\(receipt.total, specifier: "%.2f")")
                    .bold()
                    .italic()
            }
        }
    }
}

struct SubreceiptCell: View {
    var subreceipt: Subreceipt
    
    var body: some View {
        PreviewCell {
            VStack(alignment: .leading) {
                HStack {
                    Text(subreceipt.restaurantName)
                        .font(.title3)
                        .bold()
                        .italic()
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("on \(subreceipt.date.formatted(date: .numeric, time: .omitted))")
                        
                        Text("Ordered:")
                        
                        VStack {
                            ForEach(subreceipt.allFood) { food in
                                Text(food.name)
                            }
                        }
                        .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Text("$\(subreceipt.totalWithExtrasDue, specifier: "%.2f")")
                        .bold()
                }
                
            }
        }
    }
}

struct RestaurantCell: View {
    var restaurant: Restaurant
    
    var body: some View {
        PreviewCell {
            VStack(alignment: .leading) {
                HStack {
                    Text(restaurant.name)
                        .font(.title3)
                        .bold()
                        .italic()
                    
                    Spacer()
                }
                
                Text("Total Spent: $\(restaurant.totalSpent, specifier: "%.2f")")
                
            }
        }
    }
}

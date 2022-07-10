//
//  SubreceiptView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/6/22.
//

import SwiftUI

struct SubreceiptView: View {
    @ObservedObject var subreceipt: Subreceipt
    var dc: DataController
    var askToRemoveAction: () -> Void
    var totalDue: Double
    var tax: Double
    var tip: Double
    var fees: Double
    
    
    init(dc: DataController, subreceipt: Subreceipt, totalDue: Double, tax: Double, tip: Double, fees: Double, askToRemove: @escaping ()->Void) {
        self.dc = dc
        _subreceipt = ObservedObject(wrappedValue: subreceipt)
        
        self.totalDue = totalDue
        self.tax = tax
        self.tip = tip
        self.fees = fees
        self.askToRemoveAction = askToRemove
    }
    
    /// Initializer for when the view will not be displayed along side other items on the receipt
    /// - Parameters:
    ///   - dc: DataController object
    ///   - subreceipt: The subreceipt which will provide totalDue, tax, tip, and fee values.
    ///   - askToRemove: The action to perform when the user taps remove inside SubreceiptView.
    init(dc: DataController, subreceipt: Subreceipt, askToRemove: @escaping () -> Void) {
        self.dc = dc
        _subreceipt = ObservedObject(wrappedValue: subreceipt)
        
        self.totalDue = subreceipt.totalDue
        self.tax = subreceipt.splitTaxAmount
        self.tip = subreceipt.splitTipAmount
        self.fees = subreceipt.splitFeesAmount
        
        self.askToRemoveAction = askToRemove
    }
    
    var body: some View {
        Section {
            VStack(alignment: .trailing) {
                HStack {
                    Text(subreceipt.person!.name)
                        .font(.title)
                        .bold()
                    Spacer()
                    Text("Total Due: \(subreceipt.totalWithExtrasDue, specifier: "%.2f")")
                        .bold()
                }
            }
            
            ForEach(subreceipt.allFood) { food in
                NavigationLink {
                    CreateEditFood(dc: dc, person: subreceipt.person!, food: subreceipt.allFood, subreceipt: subreceipt)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Item: \(food.name)")
                            .font(.title3)

                        Text("Menu Price: $\(food.cd_subtotal, specifier: "%.2f")")
                            .italic()
                            .padding(.leading, 10)
                    }
                    .font(.subheadline)
                }
            }
            
            Group {
                if tax != 0 {
                    Text("Tax: $\(tax, specifier: "%.2f")")
                }
                
                if tip != 0 {
                    Text("Tip: $\(tip, specifier: "%.2f")")
                }
                
                if fees != 0 {
                    Text("Service Fees: $\(fees, specifier: "%.2f")")
                }
            }
            .font(.subheadline)
            .padding(.leading, 10)

            
            NavigationLink {
                CreateEditFood(dc: dc, person: subreceipt.person!, food: subreceipt.allFood, subreceipt: subreceipt)
            } label: {
                Label("Add Food", systemImage: "plus.circle")
            }
            
            ThemedButton(.removePerson) {
                askToRemoveAction()
            }
        }

    }
}

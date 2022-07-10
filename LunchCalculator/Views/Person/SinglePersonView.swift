//
//  SinglePersonView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct SinglePersonView: View {
    var dc: DataController
    @ObservedObject var person: Person
    
    var body: some View {
        ReusableList {
            Group {
                person.totalPaid
                    .bold()
                    .font(.title)
                
                Section(header: Text("All Food")) {
                    ForEach(person.allFood) { food in
                        
                        NavigationLink {
                            SingleFoodView(dc, food: food)
                        } label: {
                            FoodCell(food: food)
                        }
                    }
                }
                
                Section(header: Text("All Subreceipts")) {
                    ForEach(person.allSubreceipts) { subreceipt in
                        NavigationLink {
                            Form {
                                SubreceiptView(dc: dc, subreceipt: subreceipt) {
                                    //
                                }
                            }
                            .navigationTitle(Text("\(subreceipt.restaurantName)"))
                            
                        } label: {
                            SubreceiptCell(subreceipt: subreceipt)
                        }

                        
                    }
                }
            }
        }
        .navigationTitle(person.name)
    }
    
    func foodLabel(_ food: Food) -> String {
        "\(food.name) on \(food.date.formatted(date: .numeric, time: .omitted)) from \(food.restaurantName)"
    }
}

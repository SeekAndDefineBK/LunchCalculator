//
//  SinglePersonView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct SinglePersonView: View {
    @ObservedObject var person: Person
    
    var body: some View {
        List {
            person.totalPaid
                .bold()
                .font(.title)
            
            Section(header: Text("All Food")) {
                ForEach(person.allFood) { food in
                    VStack(alignment: .leading) {
                        Text("\(food.name) on \(food.date.formatted(date: .numeric, time: .omitted)) from \(food.restaurantName)")
                        
                        Text("Price: $\(food.total, specifier: "%.2f")")
                    }
                    
                }
            }
            
            Section(header: Text("All Restaurants")) {
                ForEach(person.allSubreceipts) { subreceipt in
                    Text(subreceipt.restaurantName)
                }
            }
        }
        .navigationTitle(person.name)
    }
}

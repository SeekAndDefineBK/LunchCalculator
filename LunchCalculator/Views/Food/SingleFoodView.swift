//
//  SingleFoodView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/4/22.
//

import SwiftUI

struct SingleFoodView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var food: Food
    @ObservedObject var dc: DataController
    
    @State private var showingDeleteAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    init(_ dc: DataController, food: Food) {
        self.dc = dc
        _food = ObservedObject(wrappedValue: food)
    }
    
    var body: some View {
        List {
            Text("\(food.restaurantName) on \(food.date.formatted(date: .numeric, time: .omitted))")
            Text("Purchased by: \(food.person?.name ?? "Unknown")")
            Text("Subtotal: $\(food.cd_subtotal, specifier: "%.2f")")
            Text("Tax: \(food.tax, specifier: "%.2f")")
            Text("Total: $\(food.totalWithTax, specifier: "%.2f")")
                .bold()
            
            Section {
                Button(role: .destructive) {
                    triggerDeleteAlert()
                } label: {
                    Label("Delete Food", systemImage: "trash.fill")
                }
            }
        }
        .navigationTitle(food.name)
        .alert(alertTitle, isPresented: $showingDeleteAlert) {
            Button(role: .destructive) {
                dc.delete(food)
                dismiss()
            } label: {
                Text("Delete")
            }

        } message: {
            Text(alertMessage)
        }
    }
    
    func triggerDeleteAlert() {
        alertTitle = "Delete \(food.name)"
        alertMessage = "Are you sure you want to delete \(food.name)? This cannot be undone."
        showingDeleteAlert = true
    }
}

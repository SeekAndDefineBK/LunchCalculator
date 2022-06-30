//
//  SingleRestaurantView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct SingleRestaurantView: View {
    @ObservedObject var dc: DataController
    @ObservedObject var restaurant: Restaurant
    @State private var showingDeleteAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    init(dc: DataController, _ restaurant: Restaurant) {
        _restaurant = ObservedObject(wrappedValue: restaurant)
        _dc = ObservedObject(wrappedValue: dc)
    }
    
    var body: some View {
        List {
            Section(header: Text("All Receipts")) {
                ForEach(restaurant.allReceipts) { receipt in
                    NavigationLink {
                        ReceiptView(dc: dc, receipt: receipt, restaurant: restaurant)
                    } label: {
                        receipt.titleView
                    }
                }
            }
            
            Section(header: Text("All Food")) {
                ForEach(restaurant.allFood) { food in
                    NavigationLink {
                        Text(food.name)
                    } label: {
                        Text(food.name)
                    }
                }
            }
            
            Button {
              showingDeleteAlert = true
            } label: {
                Label("Delete Restaurant", systemImage: "trash.fill")
            }
            .foregroundColor(.red)
            
        }
        .navigationTitle(restaurant.name)
        .alert(alertTitle, isPresented: $showingDeleteAlert) {
            Button(role: .destructive) {
                dc.delete(restaurant)
            } label: {
                Text("Yes")
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    func showDeleteAlert() {
        alertTitle = "Delete \(restaurant.name)"
        alertMessage = "Are you sure you want to delete \(restaurant.name)? This cannot be undone."
        showingDeleteAlert = true
    }
}

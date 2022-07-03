//
//  ContentView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation
import CoreData

extension ReceiptView {
    class ReceiptView_Model: ObservableObject {
        var dc: DataController
        var restaurant: Restaurant
        @Published var receipt: Receipt

        @Published var selectedFoodIndex: Int = 0
        @Published var showEditFood = false
        
        @Published var showingDeleteAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        @Published var fees: Double
        @Published var tax: Double
        @Published var tip: Double

        init(dc: DataController, receipt: Receipt, restaurant: Restaurant) {
            self.dc = dc
            self.receipt = receipt
            self.restaurant = restaurant
            
            _fees = Published(wrappedValue: receipt.cd_fees)
            _tax = Published(wrappedValue: receipt.cd_tax)
            _tip = Published(wrappedValue: receipt.cd_tip)
        }
        
        func askToDelete() {
            alertTitle = "Delete this Receipt?"
            alertMessage = "Are you sure you want to delete this receipt? This cannot be undone."
            showingDeleteAlert = true
        }
    }
}

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
        @Published var showingRemovePersonAlert = false
        @Published var removePersonAction: () -> Void = {  }
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
        
        
        //MARK: Receipt Data Management
        func askToDelete() {
            alertTitle = "Delete this Receipt?"
            alertMessage = "Are you sure you want to delete this receipt? This cannot be undone."
            showingDeleteAlert = true
        }
        
        func askToRemove(subreceipt: Subreceipt) {
            alertTitle = "Remove \(subreceipt.person!.name)"
            alertMessage = "Are you sure you want to remove \(subreceipt.person!.name) from the bill for \(subreceipt.restaurantName)? This cannot be undone."
            
            removePersonAction = {
                self.dc.delete(subreceipt)
            }
            
            showingRemovePersonAlert = true
        }
        
        
        //MARK: Tax/Tip/Fees Display methods
        func calculateSplit(_ subreceipt: Subreceipt) -> Double {
            let tax = calculateTax(subreceipt)
            let tip = calculateTip(subreceipt)
            let fees = calculateFees(subreceipt)
            
            return subreceipt.totalDue + tax + tip + fees
        }
        
        func calculateTip(_ subreceipt: Subreceipt) -> Double {
            let percentageOfTip = subreceipt.totalDue / receipt.subtotal
            
            return tip * percentageOfTip
        }
        
        func calculateTax(_ subreceipt: Subreceipt) -> Double {
            let percentageOfTax = subreceipt.totalDue / receipt.subtotal
            
            return tax * percentageOfTax
        }
        
        func calculateFees(_ subreceipt: Subreceipt) -> Double {
            let percentageOfFees = subreceipt.totalDue / receipt.subtotal
            
            return fees * percentageOfFees
        }
    }
}

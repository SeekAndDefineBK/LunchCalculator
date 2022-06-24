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
        @Published var receipt: Receipt

        @Published var showingAddPerson = false
        @Published var showingAddFood = false

        @Published var selectedPersonIndex: Int = 0
        @Published var selectedFoodIndex: Int = 0
        @Published var showEditFood = false
        
        @Published var showingDeleteAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""

        init(dc: DataController, receipt: Receipt) {
            self.dc = dc
            self.receipt = receipt
        }
        
        func askToDelete() {
            alertTitle = "Delete this Receipt?"
            alertMessage = "Are you sure you want to delete this receipt? This cannot be undone."
            showingDeleteAlert = true
        }
    }
}

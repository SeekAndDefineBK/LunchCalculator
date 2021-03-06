//
//  SelectPersonView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import SwiftUI

struct SelectPersonView: View {
    @Environment(\.dismiss) var dismiss
    var dc: DataController
    var receipt: Receipt
    var restaurant: Restaurant
    
    //TODO: Convert person to array of Person to allow multiple selection
    @State private var allPeople: [Person]
    @State private var showingAddPerson = false
    
    init(dc: DataController, receipt: Receipt, restaurant: Restaurant) {
        self.dc = dc
        self.receipt = receipt
        self.restaurant = restaurant
        
        _allPeople = State(wrappedValue: receipt.allPeople)
    }
    
    var body: some View {
        Form {
            Section {
                PeoplePickerView(dc: dc, selectedPeople: $allPeople, receipt: receipt)
            }
            
            //Hide button that tells user they can create a new person
            //And hide SelectPersonView Save button, because the CreatePersonView Save button will now handle saving
            if !showingAddPerson {
                Section {
                    ThemedButton(.createPerson) {
                        withAnimation {
                            showingAddPerson = true
                        }
                    }
                    
                    ThemedButton(.save) {
                        showingAddPerson = false
                        saveAction()
                    }
                }
            } else {
                CreatePersonView(dc: dc, receipt: receipt, restaurant: restaurant, onDisplay: $showingAddPerson)
            }
        }
    }
    
    func saveAction() {        
        for person in allPeople {
            dc.addPersonToReceipt(person, receipt: receipt)
        }

        dismiss()
    }
}



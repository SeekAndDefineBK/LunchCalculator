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
    @State private var person: Person?
    @State private var showingAddPerson = false
    @State private var newFoods: [FoodData] = []
    
    var body: some View {
        Form {
            Section {
                PeoplePickerView(dc: dc, selectedPerson: $person, receipt: receipt)
            }
            
            //Hide button that tells user they can create a new person
            //And hide SelectPersonView Save button, because the CreatePersonView Save button will now handle saving
            if !showingAddPerson {
                Section {
                    Button {
                        withAnimation {
                            showingAddPerson = true
                        }
                    } label: {
                        Label("Create Person", systemImage: "person.crop.circle.fill.badge.plus")
                    }
                    
                    Button {
                        if person != nil {
                            dc.addPersonToReceipt(person!, receipt: receipt)
                            dismiss()
                        }
                    } label: {
                        Label("Save", systemImage: "")
                    }
                }
            }
            
            if showingAddPerson {
                CreatePersonView(dc: dc, receipt: receipt, restaurant: restaurant) {
                    saveAction()
                }
            }
        }
    }
    
    func saveAction() {
        if person != nil {
            dc.addPersonToReceipt(person!, receipt: receipt)
        }
        dismiss()
    }
}



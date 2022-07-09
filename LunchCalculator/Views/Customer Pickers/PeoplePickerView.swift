//
//  PeoplePickerView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import SwiftUI

struct PeoplePickerView: View {
    @StateObject var vm: PeoplePickerView_Model
    static let tag = "People"
    
    @Binding var selectedPeople: [Person]
    var receipt: Receipt
    
    init(dc: DataController, selectedPeople: Binding<[Person]>, receipt: Receipt) {
        let viewModel = PeoplePickerView_Model(
            dc: dc
        )
        
        _vm = StateObject(wrappedValue: viewModel)
        _selectedPeople = selectedPeople
        self.receipt = receipt
    }
    
    var body: some View {
        List {
            ForEach(vm.allPeople) { person in
                
                
                Button {
                    if selectedPeople.contains(person) {
                        selectedPeople.removeAll(where: {$0 == person})
                    } else {
                        selectedPeople.append(person)
                    }
                } label: {
                    Label(person.name, systemImage: updateSelectedDisplay(person) ? "checkmark" : "")
                        .foregroundColor(.black)
                        .accessibilityHint(updateSelectedDisplay(person) ? "selected \(person.name)" : "unselected \(person.name)")
                }
                .disabled(disableUnselect(person))
            }
        }
    }
    
    func updateSelectedDisplay(_ person: Person) -> Bool {
        selectedPeople.contains(person)
    }
    
    func disableUnselect(_ person: Person) -> Bool {
        receipt.allPeople.contains(person) 
    }
}

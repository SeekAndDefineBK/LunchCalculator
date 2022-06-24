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
    
    @Binding var selectedPerson: Person?
    var receipt: Receipt
    
    
    init(dc: DataController, selectedPerson: Binding<Person?>, receipt: Receipt) {
        let viewModel = PeoplePickerView_Model(
            dc: dc
        )
        
        _vm = StateObject(wrappedValue: viewModel)
        _selectedPerson = selectedPerson
        self.receipt = receipt
    }
    
    var body: some View {
        List {
            Picker(selection: $selectedPerson) {
                ForEach(vm.allPeople) { person in
                    Text(person.name)
                        .tag(person as Person?)
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.inline)
            .navigationTitle("Person Picker")

        }
    }
}

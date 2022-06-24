//
//  AllPeopleView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import SwiftUI

struct AllPeopleView: View {
    @StateObject var vm: AllPeopleView_Model
    static let tag = "People"
    
    init(dc: DataController) {
        let viewModel = AllPeopleView_Model(
            dc: dc
        )
        
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.allPeople) { person in
                    Text(person.name)
                }
                .onDelete { offsets in
                    vm.delete(offsets)
                }
            }
            .navigationTitle("All People")
        }
    }
}

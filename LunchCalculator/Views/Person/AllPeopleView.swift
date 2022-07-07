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
            ReusableList {
                Group {
                    ForEach(vm.allPeople) { person in
                        NavigationLink(person.name) {
                            SinglePersonView(dc: vm.dc, person: person)
                        }

                    }
                    .onDelete { offsets in
                        vm.delete(offsets)
                    }
                }
            }
            .navigationTitle("All People")
        }
    }
}

//
//  CreateEditFood.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct CreateEditFood: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: CreateEditFood_Model
    
    init(dc: DataController, person: Person, food: Food? = nil) {
        let viewModel = CreateEditFood_Model(dc: dc, person: person, food: food)
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section {
                TextFieldHStack(rs: "Food Name:", ls: $vm.name)
                TextFieldHStack(rs: "Price:", ls: $vm.price)
                TextFieldHStack(rs: "Tax:", ls: $vm.tax)
                TextFieldHStack(rs: "Tip:", ls: $vm.tip)
                TextFieldHStack(rs: "Service Fees:", ls: $vm.fees)
            }
            
            Button {
                vm.createFood()
                dismiss()
            } label: {
                Label("Save Food", image: "plus.circle")
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showingQCAlert) {
            Button {
                //
            } label: {
                Text("Okay")
            }

        } message: {
            Text(vm.alertMessage)
        }
    }
}

//
//  CreatePersonView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct CreatePersonView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: CreatePersonView_Model
    
    init(dc: DataController, person: Person? = nil, receipt: Receipt, onSaveAction: @escaping () -> Void) {
        let viewModel = CreatePersonView_Model(dc: dc, person: person, onSaveAction: onSaveAction)
        _vm = StateObject(wrappedValue: viewModel)
        self.receipt = receipt
    }
    
    @State private var foodData: [FoodData] = [FoodData]()
    private var receipt: Receipt
    
    var body: some View {
        List {
            Section {
                TextFieldHStack(rs: "Name", ls: $vm.personData.name)
                
                ForEach($foodData) { $fdata in
                    Section {
                        FoodForm(
                            foodData: $fdata
                        )
                    }
                }
                
                Button {
                    withAnimation {
                        foodData.append(FoodData.blank())
                    }
                } label: {
                    Label(foodData.isEmpty ? "Add Food?" : "Add More?", systemImage: "plus.circle")
                }

                Button {
                    vm.dc.combinedCreation(
                        personData: vm.personData,
                        foodData: foodData,
                        receipt: receipt
                    )
                    
                    vm.onSaveAction()
                } label: {
                    Label("Save", systemImage: "person.crop.circle.fill.badge.plus")
                }
                
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

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
    
    init(dc: DataController, person: Person? = nil) {
        let viewModel = CreatePersonView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    @State private var foodData = [FoodData]()
    
    var body: some View {
        Form {
            Section {
                TextFieldHStack(rs: "Name", ls: $vm.personData.name)
            }
            
            ForEach($foodData) { $fdata in
                Section {
                    FoodForm(
                        foodData: $fdata
                    )
                }
            }
            
            Section {
                Button {
                    foodData.append(FoodData.blank)
                } label: {
                    Label(foodData.isEmpty ? "Add Food?" : "Add More?", systemImage: "plus.circle")
                }
            }
            
            Section {
                Button {
                    vm.dc.combinedCreation(
                        personData: vm.personData,
                        foodData: foodData,
                        receipt: vm.personData.subreceipt?.receipt
                    )
                    dismiss()
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

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
    
    /// Initializer that is used for adding Food outside of the create person view or for viewing previously created foods
    /// - Parameters:
    ///   - dc: DataController from the environment
    ///   - person: Person who will be assigned or is currently assigned to the food
    ///   - food: Optional value of Food. If NIL, new food will be created. If Not-NIL, food will be edited
    init(dc: DataController, person: Person, food: Food? = nil, subreceipt: Subreceipt) {
        let viewModel = CreateEditFood_Model(dc: dc, person: person, food: food, subreceipt: subreceipt)
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section {
                FoodForm(
                    foodData: $vm.foodData
                )
            }
            
            Button {
                vm.createFood {
                    dismiss()
                }
            } label: {
                Label("Save Food", systemImage: "plus.circle")
            }
            
            if vm.food != nil {
                Button(role: .destructive) {
                    vm.alertTitle = "Delete this item?"
                    vm.alertMessage = "Are you sure you want to delete this item? This action cannot be undone."
                    vm.showingDeleteAlert = true
                } label: {
                    Label("Delete food?", systemImage: "delete.left.fill")
                        .foregroundColor(.red)
                }
            }
            
        }
        .alert(vm.alertTitle, isPresented: $vm.showingQCAlert) {
            Button {
                //TODO: Is this necessary? Found a bug where if this appears dismiss() no longer works... testing if this helps.
                vm.alertTitle = ""
                vm.alertMessage = ""
                vm.showingQCAlert = false
            } label: {
                Text("Okay")
            }

        } message: {
            Text(vm.alertMessage)
        }
        
        .alert(vm.alertTitle, isPresented: $vm.showingOptionalQC) {
            Button {
                vm.alertAction
            } label: {
                Text("No")
            }
            
            Button {
                //TODO: Is this necessary? Found a bug where if this appears dismiss() no longer works... testing if this helps.
                vm.alertTitle = ""
                vm.alertMessage = ""
                vm.showingQCAlert = false
            } label: {
                Text("Yes")
            }

        } message: {
            Text(vm.alertMessage)
        }
        
        .alert(vm.alertTitle, isPresented: $vm.showingDeleteAlert) {
            
            Button(role: .cancel) {
                //
            } label: {
                Text("Cancel")
            }

            Button(role: .destructive) {
                vm.dc.delete(vm.food!)
                dismiss()
            } label: {
                Text("Delete")
            }
        } message: {
            Text(vm.alertMessage)
        }
        .navigationTitle(vm.food == nil ? "Add Food" : "Edit Food")
    }
}

/// Raw view of all fields the user will fill out for creating food. This exists because it will also be used when creating food at the time as creating a new person
struct FoodForm: View {
    @Binding var foodData: FoodData
    
    var body: some View {
        Section {
            TextFieldHStack(rs: "Food name", ls: $foodData.name)
            DoubleFieldHStack(rs: "Menu Price", ls: $foodData.subtotal)
        }
    }
}

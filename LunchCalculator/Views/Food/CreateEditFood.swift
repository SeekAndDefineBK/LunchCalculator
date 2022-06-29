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
    init(dc: DataController, person: Person, food: [Food], subreceipt: Subreceipt) {
        let viewModel = CreateEditFood_Model(dc: dc, person: person, allFood: food, subreceipt: subreceipt)
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section {
                ForEach(vm.allFood) { food in
                    FoodForm(food, save: vm.dc.save, delete: deleteAction)
                    
//                    Button(role: .destructive) {
//                        vm.alertTitle = "Delete this item?"
//                        vm.alertMessage = "Are you sure you want to delete this item? This action cannot be undone."
//
//                        vm.deleteAction = deleteAction(food)
//
//                        vm.showingDeleteAlert = true
//                    } label: {
//                        Label("Delete food?", systemImage: "delete.left.fill")
//                            .foregroundColor(.red)
//                    }
                }
                Button {
                    vm.addNewFood()
                } label: {
                    Label("Add Food", systemImage: "plus.circle")
                }
            }
            
            Button {
                dismiss()
            } label: {
                Label("Save Food", systemImage: "plus.circle")
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showingDeleteAlert) {
            
            Button(role: .cancel) {
                //
            } label: {
                Text("Cancel")
            }

            Button(role: .destructive) {
//                vm.deleteAction()
                dismiss()
            } label: {
                Text("Delete")
            }
        } message: {
            Text(vm.alertMessage)
        }
        .navigationTitle("Add Food")
    }
    
    func deleteAction(_ food: Food) {
        vm.person.objectWillChange.send()
        
        vm.allFood.removeAll(where: {$0.id == food.id})
        
        vm.dc.delete(food)
    }
}

/// Raw view of all fields the user will fill out for creating food. This exists because it will also be used when creating food at the time as creating a new person
struct FoodForm: View {
    @ObservedObject var food: Food
    
    @State private var name = ""
    @State private var subtotal: Double = 0
    
    let save: () -> Void
    let delete: (Food) -> Void
    
    @State private var showingDeleteAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    init(_ food: Food, save: @escaping () -> Void, delete: @escaping (Food) -> Void) {
        _food = ObservedObject(wrappedValue: food)
        
        _name = State(wrappedValue: food.name)
        _subtotal = State(wrappedValue: food.cd_subtotal)
        
        self.save = save
        self.delete = delete
    }
    
    var body: some View {
        Section {
            HStack {
                TextFieldHStack(rs: "Food name", ls: $name.onChange(update))
                Button {
                    showDeleteAlert()
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                        .labelStyle(.iconOnly)
                }
                .foregroundColor(.red)

            }
            DoubleFieldHStack(rs: "Menu Price", ls: $subtotal.onChange(update))
        }
        .alert(alertTitle, isPresented: $showingDeleteAlert) {
            Button(role: .destructive) {
                withAnimation {
                    delete(food)
                }
            } label: {
                Text("Yes")
            }

        } message: {
            Text(alertMessage)
        }
    }
    
    func showDeleteAlert() {
        alertTitle = "Delete Food?"
        alertMessage = "Are you sure you want to delete \(food.name)? This cannot be undone."
        showingDeleteAlert = true
    }
    
    func update() {
        
        food.objectWillChange.send()
        
        food.cd_name = name
        food.cd_subtotal = subtotal
        
        save()
    }
}

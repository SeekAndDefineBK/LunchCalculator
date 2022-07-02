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
    
    init(dc: DataController, person: Person? = nil, receipt: Receipt, restaurant: Restaurant, onSaveAction: @escaping () -> Void) {
        let viewModel = CreatePersonView_Model(dc: dc, person: person, onSaveAction: onSaveAction)
        _vm = StateObject(wrappedValue: viewModel)
        self.receipt = receipt
        self.restaurant = restaurant
        
        var newFood = FoodData.blank()
        newFood.person = person
        
        _allFood = State(wrappedValue: [dc.createBlankFood()])
    }
    
    @State private var allFood: [Food]
    private var receipt: Receipt
    private var restaurant: Restaurant
    
    @FocusState var focused: String?

    
    var body: some View {
        List {
            Section {
                TextFieldHStack(rs: "Name", ls: $vm.personData.name)
                
                ForEach(allFood) { food in
                    Section {
                        FoodForm(
                            food,
                            save: vm.dc.save,
                            focus: _focused,
                            index: allFood.firstIndex(where: {$0 == food})!
                        )
                    }
                }
                
                Button {
                    withAnimation {
                        let newFood = vm.dc.createBlankFood()
                        
                        allFood.append(newFood)
                        
                    }
                } label: {
                    Label(allFood.isEmpty ? "Add Food?" : "Add More?", systemImage: "plus.circle")
                }

                Button {
                    vm.dc.combinedCreation(
                        personData: vm.personData,
                        allFood: allFood,
                        receipt: receipt, restaurant: restaurant
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
    
    func deleteFood(_ food: Food) {
        vm.person?.objectWillChange.send()
        
        allFood.removeAll(where: {$0.id == food.id})
        
        vm.dc.delete(food)
    }
}

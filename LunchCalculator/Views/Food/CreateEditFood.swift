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
    ///   - subreceipt: 
    init(dc: DataController, person: Person, food: [Food], subreceipt: Subreceipt) {
        let viewModel = CreateEditFood_Model(dc: dc, person: person, allFood: food, subreceipt: subreceipt)
        _vm = StateObject(wrappedValue: viewModel)
    }

    @FocusState var focused: String?
    @State private var focusedIndex = 0
    
    @State private var showingDeleteAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section {
                ForEach(vm.allFood) { food in
                    FoodForm(
                        food,
                        save: vm.dc.save,
                        focus: _focused,
                        index: vm.allFood.firstIndex(where: {$0 == food})!
                    )
                    .onTapGesture {
                        assignFocus(food)
                    }
                }
                .onDelete { offsets in
                    vm.delete(offsets)
                }
                
                Button {
                    dismiss()
                } label: {
                    Label("Save Food", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle("\(vm.person.name)'s Food")
        .alert(vm.alertTitle, isPresented: $vm.showingDeleteAlert) {
            Button(role: .destructive) {
                dismiss()
            } label: {
                Text("Delete")
            }
        } message: {
            Text(vm.alertMessage)
        }
        .alert(alertTitle, isPresented: $showingDeleteAlert) {
            Button(role: .destructive) {
                withAnimation {
                    deleteAction(vm.allFood[focusedIndex])
                }
            } label: {
                Text("Yes")
            }

        } message: {
            Text(alertMessage)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                KeyboardButton(disabled: isPreviousDisabled(), navigation: .previous) {
                    switchFocus(.previous)
                }
                
                KeyboardButton(disabled: isNextDisabled(), navigation: .next) {
                    switchFocus(.next)
                }
                
                Spacer()
                
                Button {
                    showDeleteAlert()
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                    vm.addNewFood()
                } label: {
                    Label("Add Food", systemImage: "plus.circle")
                }
                
                Button {
                    focused = nil
                } label: {
                    Label("Done", systemImage: "checkmark.circle.fill")
                }

            }
        }
    }
    
    func showDeleteAlert() {
        alertTitle = "Delete Food?"
        
        var foodName: String {
            if vm.allFood[focusedIndex].name == "" {
                return "Unnamed food"
            } else {
                return vm.allFood[focusedIndex].name
            }
        }
        
        alertMessage = "Are you sure you want to delete \(foodName)? This cannot be undone."
        showingDeleteAlert = true
    }
            
    func assignFocus(_ food: Food) {
        focusedIndex = vm.allFood.firstIndex(where: { $0 == food })!
    }
    
    func isPreviousDisabled() -> Bool {
        if vm.allFood.count == 0 {
            return true
        } else {
            return focused == "\(0).name"
        }
    }
    
    func isNextDisabled() -> Bool {
        if vm.allFood.count == 0 {
            return true
        } else {
            let lastIndex = vm.allFood.count - 1
            return focused == "\(lastIndex).price"
        }
    }
    
    func switchFocus(_ direction: KeyboardButton.NavigationOptions) {
        switch focused {
            
        case "\(focusedIndex).name":
            switch direction {
            
            case .next:
                focused = "\(focusedIndex).price"
            
            case .previous:
                let previousIndex: Int = focusedIndex - 1
                
                if previousIndex < 0 {
                    focused = nil
                    focusedIndex = 0
                } else {
                    focused = "\(previousIndex).price"
                    focusedIndex = previousIndex
                }
            }
            
        case "\(focusedIndex).price":
            
            switch direction {
            case .next:
                let nextIndex = focusedIndex + 1
                
                if nextIndex > vm.allFood.count - 1 {
                    focused = nil
                    focusedIndex = 0
                } else {
                    focused = "\(nextIndex).name"
                    focusedIndex = nextIndex
                }
                
            case .previous:
                focused = "\(focusedIndex).name"
            }
            
        default:
            focused = nil
        }
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
    
    @FocusState var focused: String?
    
    @State private var name = ""
    @State private var subtotal: Double = 0
    
    let save: () -> Void
    let index: Int
    
    init(_ food: Food, save: @escaping () -> Void, focus: FocusState<String?>, index: Int) {
        _food = ObservedObject(wrappedValue: food)
        
        _name = State(wrappedValue: food.name)
        _subtotal = State(wrappedValue: food.cd_subtotal)
        _focused = focus
        
        self.save = save
        self.index = index
    }
    
    var body: some View {
        Section {
            TextFieldHStack(rs: "Food name", ls: $name.onChange(update))
                .focused($focused, equals: "\(index).name")
            DoubleFieldHStack(rs: "Menu Price", ls: $subtotal.onChange(update))
                .focused($focused, equals: "\(index).price")
        }
    }
    
    func update() {
        
        food.objectWillChange.send()
        
        food.cd_name = name
        food.cd_subtotal = subtotal
        
        save()
    }
}

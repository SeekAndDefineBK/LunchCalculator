//
//  ContentView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ContentView_Model
    
    init(dc: DataController) {
        let viewModel = ContentView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(vm.allPeople) { person in
                    Section {
                        HStack {
                            Text(person.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            Text("Total Due: \(person.allFood.reduce(0) { $0 + $1.total }, specifier: "%.2f")")
                                .bold()
                        }
                        
                        ForEach(person.allFood) { food in
                            VStack(alignment: .leading) {
                                Text("Item: \(food.name)")
                                    .font(.title3)
                                
                                Text("  Price: $\(food.cd_tax, specifier: "%.2f")")
                                Text("  Price: $\(food.cd_tip, specifier: "%.2f")")
                                Text("  Price: $\(food.cd_fees, specifier: "%.2f")")
                                Text("  Subtotal: $\(food.cd_subtotal, specifier: "%.2f")")
                                    .italic()
                            }
                            .font(.subheadline)
                            .onTapGesture {
                                if let index = vm.allPeople.firstIndex(where: {$0.id == person.id}) {
                                    vm.selectedPersonIndex = index
                                    
                                    if let foodIndex = person.allFood.firstIndex(where: {$0.id == food.id}) {
                                        vm.selectedFoodIndex = foodIndex
                                        
                                        vm.showEditFood = true
                                        vm.showingAddFood = true
                                    }
                                }
                            }
                        }
                        
                        Button {
                            if let index = vm.allPeople.firstIndex(where: {$0.id == person.id}) {
                                vm.selectedPersonIndex = index
                                vm.showingAddFood = true
                            }
                        } label: {
                            Label("Add Food", systemImage: "plus.circle")
                        }
                    }
                }
                
                Button {
                    vm.showingAddPerson = true
                } label: {
                    Label("Add Person", systemImage: "person.crop.circle.fill.badge.plus")
                }
            }
            .navigationTitle("Lunch Calculator")
        }
        .sheet(isPresented: $vm.showingAddPerson) {
            CreatePersonView(dc: vm.dc)
        }
        .sheet(isPresented: $vm.showingAddFood) {
            
            if vm.showEditFood {
                CreateEditFood(
                    dc: vm.dc,
                    person: vm.allPeople[vm.selectedPersonIndex],
                    food: vm.allPeople[vm.selectedPersonIndex].allFood[vm.selectedFoodIndex]
                )
            } else {
                CreateEditFood(
                    dc: vm.dc,
                    person: vm.allPeople[vm.selectedPersonIndex]
                )
            }
            
        }
    }
}



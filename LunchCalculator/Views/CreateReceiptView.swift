//
//  ContentView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct CreateReceiptView: View {
    @StateObject var vm: CreateReceiptView_Model
    static let tag = "NewReceipt"
    
    init(dc: DataController) {
        let viewModel = CreateReceiptView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
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
                            
                            NavigationLink {
                                CreateEditFood(dc: vm.dc, person: person, food: food)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("Item: \(food.name)")
                                        .font(.title3)

                                    VStack(alignment: .leading) {
                                        Text("Menu Price: $\(food.cd_subtotal, specifier: "%.2f")")
                                        Text("Subtotal: \(food.total, specifier: "%.2f")")
                                            .italic()
                                            .bold()
                                    }
                                    .padding(.leading, 10)
                                    
                                }
                                .font(.subheadline)
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
            CreateEditFood(
                dc: vm.dc,
                person: vm.allPeople[vm.selectedPersonIndex]
            )
        }
    }
}



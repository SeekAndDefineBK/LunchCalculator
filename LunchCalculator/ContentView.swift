//
//  ContentView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var people: [People] = []
    @State private var showingAddPerson = false
    @State private var showingAddFood = false

    @State private var selectedPersonIndex: Int = 0
    @State private var selectedFoodIndex: Int = 0
    @State private var showEditFood = false
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(people) { person in
                    Section {
                        HStack {
                            Text(person.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            Text("Total Due: \(person.food.reduce(0) { $0 + $1.total }, specifier: "%.2f")")
                                .bold()
                        }
                        
                        ForEach(person.food) { food in
                            VStack(alignment: .leading) {
                                Text("Item: \(food.name)")
                                    .font(.title3)
                                
                                Text("  Price: $\(food.tax, specifier: "%.2f")")
                                Text("  Price: $\(food.tip, specifier: "%.2f")")
                                Text("  Price: $\(food.fees, specifier: "%.2f")")
                                Text("  Subtotal: $\(food.subtotal, specifier: "%.2f")")
                                    .italic()
                            }
                            .font(.subheadline)
                            .onTapGesture {
                                if let index = people.firstIndex(where: {$0.id == person.id}) {
                                    selectedPersonIndex = index
                                    
                                    if let foodIndex = person.food.firstIndex(where: {$0.id == food.id}) {
                                        selectedFoodIndex = foodIndex
                                        
                                        showEditFood = true
                                        showingAddFood = true
                                    }
                                }
                            }

                            
                        }
                        
                        Button {
                            if let index = people.firstIndex(where: {$0.id == person.id}) {
                                selectedPersonIndex = index
                                showingAddFood = true
                            }
                        } label: {
                            Label("Add Food", systemImage: "plus.circle")
                        }
                    }
                }
                
                Button {
                    showingAddPerson = true
                } label: {
                    Label("Add Person", systemImage: "person.crop.circle.fill.badge.plus")
                }
            }
            .navigationTitle("Lunch Calculator")
        }
        .sheet(isPresented: $showingAddPerson) {
            CreatePersonView(people: $people)
        }
        .sheet(isPresented: $showingAddFood) {
            
            if showEditFood {
                CreateEditFood($people[selectedPersonIndex], food: $people[selectedPersonIndex].food[selectedFoodIndex])
            } else {
                CreateEditFood($people[selectedPersonIndex])
            }
            
        }
    }
}



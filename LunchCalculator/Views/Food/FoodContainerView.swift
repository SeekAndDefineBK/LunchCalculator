//
//  NuFoodContainer.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/4/22.
//

import SwiftUI
import CoreData

enum FoodContainerSorted: String, CaseIterable {
    case Restaurants = "Restaurants"
    case People = "People"
}

struct FoodContainerView: View {
    @StateObject var vm: FoodContainerView_Model
    @State private var sortedBy: FoodContainerSorted = .Restaurants
    
    init(dc: DataController, predicateStr: String) {
        let viewModel = FoodContainerView_Model(dc: dc, predicateStr: predicateStr)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ReusableList {
            Group {
                Text("Total Spent on \(vm.displayName): $\(vm.totalSpent, specifier: "%.2f")")
                
                Section(header: Text("All Food")) {
                    ForEach(vm.allFood) { food in
                        NavigationLink {
                            SingleFoodView(vm.dc, food: food)
                        } label: {
                            FoodCell(food: food)
                        }
                    }
                }
                
                Picker("", selection: $sortedBy) {
                    ForEach(FoodContainerSorted.allCases, id: \.self) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 25)
                
                switch sortedBy {
                case .Restaurants:
                    Section(header: Text("All Restuarants")) {
                        ForEach(vm.allRestaurants) { restaurant in
                            NavigationLink {
                                SingleRestaurantView(dc: vm.dc, restaurant)
                            } label: {
                                RestaurantCell(restaurant: restaurant)
                            }
                        }
                    }
                case .People:
                    Section(header: Text("All People")) {
                        ForEach(vm.allPeople) { person in
                            NavigationLink {
                                SinglePersonView(dc: vm.dc, person: person)
                            } label: {
                                PersonCell(person: person)
                            }
                        }
                    }
                }
            }
            
        }
        .navigationTitle(vm.displayName)
        
    }
    
    func foodLabel(_ food: Food) -> String {
        "\(vm.displayName) purchased by \(food.person?.name ?? "Unknown") at \(food.restaurantName) on \(food.date.formatted(date: .numeric, time: .omitted))"
    }
}




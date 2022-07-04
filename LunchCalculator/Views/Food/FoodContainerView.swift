//
//  SwiftUIView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/3/22.
//

import SwiftUI

struct FoodContainerView: View {
    var dc: DataController
    @State private var sortedBy: FoodContainerSorted = .Restaurants
    
    var foodContainer: FoodContainer
    
    init(dc: DataController, _ foodContainer: FoodContainer) {
        self.foodContainer = foodContainer
        self.dc = dc
    }
    
    var body: some View {
        List {
            Text("Total Spent on \(foodContainer.displayName): $\(foodContainer.totalSpent, specifier: "%.2f")")
            
            Section(header: Text("All Food")) {
                ForEach(foodContainer.allEntries) { food in
                    NavigationLink(foodLabel(food)) {
                        SingleFoodView(dc, food: food)
                    }
                    //Price per each
                }
            }
            
            Picker("", selection: $sortedBy) {
                ForEach(FoodContainerSorted.allCases, id: \.self) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
            
            switch sortedBy {
            case .Restaurants:
                Section(header: Text("All Restuarants")) {
                    ForEach(foodContainer.allRestaurants) { restaurant in
                        NavigationLink(restaurant.name) {
                            SingleRestaurantView(dc: dc, restaurant)
                        }
                    }
                }
            case .People:
                Section(header: Text("All People")) {
                    ForEach(foodContainer.allPeople) { person in
                        NavigationLink(person.name) {
                            SinglePersonView(person: person)
                        }
                    }
                }
            }
        }
        .navigationTitle(foodContainer.displayName)
    }
    
    func foodLabel(_ food: Food) -> String {
        "\(foodContainer.displayName) purchased by \(food.person?.name ?? "Unknown") at \(food.restaurantName) on \(food.date.formatted(date: .numeric, time: .omitted))"
    }
}

enum FoodContainerSorted: String, CaseIterable {
    case Restaurants = "Restaurants"
    case People = "People"
}

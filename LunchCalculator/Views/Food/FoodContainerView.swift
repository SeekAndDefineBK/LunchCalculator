//
//  SwiftUIView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/3/22.
//

import SwiftUI

struct FoodContainerView: View {
    var foodContainer: FoodContainer
    
    init(_ foodContainer: FoodContainer) {
        self.foodContainer = foodContainer
    }
    
    var body: some View {
        List {
            ForEach(foodContainer.allEntries) { food in
                Text("\(food.name) purchased at \(food.restaurantName) on \(food.date.formatted(date: .numeric, time: .omitted))")
            }
        }
        .navigationTitle(foodContainer.displayName)
    }
}


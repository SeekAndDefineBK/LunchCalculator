//
//  AllFoodView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import SwiftUI

struct AllFoodView: View {
    @StateObject var vm: AllFoodView_Model
    static let tag = "AllFood"
    
    init(dc: DataController) {
        let viewModel = AllFoodView_Model(
            dc: dc
        )
        
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.allRestaurants) { restaurant in
                    Section(header: Text(restaurant.name)) {
                        ForEach(restaurant.allFood) { food in
                            Text(food.name)
                        }
                        .onDelete { offsets in
                            vm.delete(from: restaurant, offsets)
                        }
                    }
                }
                
            }
            .navigationTitle("All Food")
        }
    }
}


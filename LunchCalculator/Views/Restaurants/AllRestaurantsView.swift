//
//  AllRestaurantsView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct AllRestaurantsView: View {
    @StateObject var vm: AllRestaurantsView_Model
    static let tag = "Restaurants"
    
    init(dc: DataController){
        let viewModel = AllRestaurantsView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ReusableList {
                Group {
                    ForEach(vm.allRestaurants) { restaurant in
                        NavigationLink("\(restaurant.name) Total Spent \(restaurant.totalSpent, specifier: "%.2f")") {
                            SingleRestaurantView(dc: vm.dc, restaurant)
                        }
                    }
                    .onDelete { offsets in
                        vm.delete(offsets)
                    }
                }
            }
            .navigationTitle("All Restaurants")
        }
    }
}

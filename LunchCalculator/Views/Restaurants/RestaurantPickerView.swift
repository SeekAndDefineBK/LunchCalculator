//
//  RestaurantPickerView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct RestaurantPickerView: View {
    @StateObject var vm: RestaurantPickerView_Model
    
    @Binding var selectedRestaurant: Restaurant?
        
    init(dc: DataController, selectedRestaurant: Binding<Restaurant?>) {
        let viewModel = RestaurantPickerView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
        
        _selectedRestaurant = selectedRestaurant
    }
    
    var body: some View {
        ReusableList {
            Group {
                Section {
                    ForEach(vm.allRestaurants) { restaurant in
                        Button {
                            if selectedRestaurant == restaurant {
                                selectedRestaurant = nil
                            } else {
                                selectedRestaurant = restaurant
                            }
                        } label: {
                            Label(restaurant.name, systemImage: selectedRestaurant == restaurant ? "checkmark" : "")
                        }
                    }
                    
                    Button {
                        selectedRestaurant = nil
                    } label: {
                        Label("None", systemImage: selectedRestaurant == nil ? "checkmark" : "")
                    }
                }
            }
        }
    }
}

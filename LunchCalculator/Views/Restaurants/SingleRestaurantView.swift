//
//  SingleRestaurantView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct SingleRestaurantView: View {
    @StateObject var vm: SingleRestaurantView_Model
    
    init(dc: DataController, _ restaurant: Restaurant) {
        let viewModel = SingleRestaurantView_Model(dc: dc, restaurant: restaurant)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ReusableList {
            Group {
                Section(header: Text("All Receipts")) {
                    ForEach(vm.restaurant.allReceipts) { receipt in
                        NavigationLink {
                            ReceiptView(dc: vm.dc, receipt: receipt, restaurant: vm.restaurant)
                        } label: {
                            ReceiptCell(receipt: receipt)
                        }
                    }
                }
                
                Section(header: Text("All Food")) {
                    ForEach(vm.allFood) { food in
                        NavigationLink {
                            SingleFoodView(vm.dc, food: food)
                        } label: {
                            FoodCell(food: food)
                        }
                    }
                    .onDelete { offsets in
                        vm.delete(offsets)
                    }
                }
            
                HStack {
                    Spacer()
                    ThemedButton(.deleteRestaurant) {
                        vm.showDeleteAlert()
                    }
                    Spacer()
                }
                .padding()
                
            }
        }
        .navigationTitle(vm.restaurant.name)
        .alert(vm.alertTitle, isPresented: $vm.showingDeleteAlert) {
            
            ThemedButton(.delete) {
                vm.dc.delete(vm.restaurant)
            }
            
        } message: {
            Text(vm.alertMessage)
        }
    }
}

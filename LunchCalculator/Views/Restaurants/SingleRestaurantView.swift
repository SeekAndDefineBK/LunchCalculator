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
        List {
            Section(header: Text("All Receipts")) {
                ForEach(vm.restaurant.allReceipts) { receipt in
                    NavigationLink {
                        ReceiptView(dc: vm.dc, receipt: receipt, restaurant: vm.restaurant)
                    } label: {
                        receipt.titleView
                    }
                }
            }
            
            Section(header: Text("All Food")) {
                ForEach(vm.allFood) { food in
                    NavigationLink {
                        SingleFoodView(vm.dc, food: food)
                    } label: {
                        HStack {
                            Text("\(food.name) for \(food.personName) on \(food.date.formatted(date: .numeric, time: .omitted))")
                            
                            Spacer()
                            
                            Text("$\(food.cd_subtotal, specifier: "%.2f")")
                                .bold()
                        }
                    }
                }
                .onDelete { offsets in
                    vm.delete(offsets)
                }
            }
            
            ThemedButton(.deleteRestaurant) {
                vm.showDeleteAlert()
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

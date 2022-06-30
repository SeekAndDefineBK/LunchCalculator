//
//  SingleRestaurantView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import SwiftUI

struct SingleRestaurantView: View {
    @ObservedObject var dc: DataController
    
    @ObservedObject var restaurant: Restaurant
    
    init(dc: DataController, _ restaurant: Restaurant) {
        _restaurant = ObservedObject(wrappedValue: restaurant)
        _dc = ObservedObject(wrappedValue: dc)
    }
    
    var body: some View {
        List {
            Section(header: Text("All Receipts")) {
                ForEach(restaurant.allReceipts) { receipt in
                    NavigationLink {
                        ReceiptView(dc: dc, receipt: receipt, restaurant: restaurant)
                    } label: {
                        receipt.titleView
                    }
                }
            }
            
            Section(header: Text("All Food")) {
                ForEach(restaurant.allFood) { food in
                    NavigationLink {
                        Text(food.name)
                    } label: {
                        Text(food.name)
                    }
                }
            }
            .navigationTitle(restaurant.name)
        }
    }
}

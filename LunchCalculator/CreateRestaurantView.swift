//
//  CreateRestaurantView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/24/22.
//

import SwiftUI

struct SelectRestaurantView: View {
    var dc: DataController
    @State private var restaurant: Restaurant?
    @State private var collapseRestaurant = false
    @State private var receipt: Receipt?
    
    @State private var restaurantData = RestaurantData()
    
    var body: some View {
        Form {
            if collapseRestaurant {
                Text(restaurant?.cd_name ?? "Unknown Restaurant")
                    .bold()
            } else {
                TextFieldHStack(rs: "Restaurant Name", ls: $restaurantData.name)
                TextFieldHStack(rs: "Address 1", ls: $restaurantData.address1)
                TextFieldHStack(rs: "Address 2", ls: $restaurantData.address2)
                TextFieldHStack(rs: "City", ls: $restaurantData.city)
                TextFieldHStack(rs: "State", ls: $restaurantData.state)
                TextFieldHStack(rs: "ZIP", ls: $restaurantData.zip)
                TextFieldHStack(rs: "Website", ls: $restaurantData.website)
                TextFieldHStack(rs: "Phone", ls: $restaurantData.phone)
            }
            
            
            if restaurant == nil && receipt == nil {
                Button {
                    updateRestaurant()
                } label: {
                    Label("Save", systemImage: "building.2.crop.circle.fill")
                }
            } else {
                //receipt and restaurant are non-nil because the app should not be usable if the below function fails
                ReceiptView(dc: dc, receipt: receipt!, restaurant: restaurant!)
            }
        }
    }
    
    func updateRestaurant() {
        collapseRestaurant = true
        
        let newRestaurant = dc.createEditRestaurant(restaurant, restaurantData: restaurantData)
        restaurant = newRestaurant
        
        let receiptData = ReceiptData(restaurant: newRestaurant, date: Date(), fees: 0, tax: 0, tip: 0)
        self.receipt = dc.createEditReceipt(nil, receiptData: receiptData, restaurant: newRestaurant)
    }
}

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
    @State private var addExistingRestaurant = false
    @State private var receipt: Receipt?
    
    @State private var restaurantData = RestaurantData()
    
    var body: some View {
        Form {
            if collapseRestaurant && receipt != nil {
                
                //MARK: The user has completed creating/choosing restaurant and can now create the bill
                Text(restaurant!.name)
                    .bold()
                
                ReceiptView(dc: dc, receipt: receipt!, restaurant: restaurant!)
                
            } else if addExistingRestaurant {
                
                //MARK: User wants to choose an exisiting Restaurant
                RestaurantPickerView(dc: dc, selectedRestaurant: $restaurant)

            } else if collapseRestaurant && receipt == nil {
                
                //MARK: User has selected an existing restaurant, but has not yet decided to move into the bill portion
                Text(restaurant!.name)
                    .bold()
                
            } else {
                
                //MARK: Default State, restaurant is nil and receipt is nil
                CreateRestaurantView(restaurantData: $restaurantData)
                
            }
            
            if receipt == nil {
                Button {
                    withAnimation {
                        addExistingRestaurant.toggle()
                        if restaurant != nil {
                            collapseRestaurant = true
                        }
                    }
                } label: {
                    Label("Select Restaurant", systemImage: "building.2.crop.circle.fill")
                }
                
                Button {
                    withAnimation { updateRestaurant() }
                } label: {
                    Label("Save", systemImage: "plus.circle")
                }
            }
        }
    }
    
    /// This will collapse the Create Restaurant user input
    /// This will create a restaurant if it is currently nil
    /// This will create a new receipt for the existing/new restaurant.
    func updateRestaurant() {
        collapseRestaurant = true
        
        if restaurant == nil {
            createRestaurant()
        }
        
        createReceipt()
    }
    
    private func createRestaurant(){
        let newRestaurant = dc.createEditRestaurant(restaurant, restaurantData: restaurantData)
        restaurant = newRestaurant
    }
    
    /// Creates a receipt for the Restaurant state object.
    /// Restaurant is not allowed to be nil, create restaurant needs to be run before this function
    private func createReceipt() {
        let receiptData = ReceiptData(restaurant: restaurant!, date: Date(), fees: 0, tax: 0, tip: 0)
        self.receipt = dc.createEditReceipt(nil, receiptData: receiptData, restaurant: restaurant!)
    }
}

struct CreateRestaurantView: View {
    @Binding var restaurantData: RestaurantData
    
    var body: some View {
        TextFieldHStack(rs: "Restaurant Name", ls: $restaurantData.name)
        TextFieldHStack(rs: "Address 1", ls: $restaurantData.address1)
        TextFieldHStack(rs: "Address 2", ls: $restaurantData.address2)
        TextFieldHStack(rs: "City", ls: $restaurantData.city)
        TextFieldHStack(rs: "State", ls: $restaurantData.state)
        TextFieldHStack(rs: "ZIP", ls: $restaurantData.zip)
        TextFieldHStack(rs: "Website", ls: $restaurantData.website)
        TextFieldHStack(rs: "Phone", ls: $restaurantData.phone)
    }
}

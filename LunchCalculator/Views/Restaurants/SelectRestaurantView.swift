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
                
                

            } else if collapseRestaurant && receipt == nil && restaurant != nil {
                
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
                    if addExistingRestaurant {
                        Text("Done")
                    } else {
                        Label(restaurant == nil
                              ? "Select Existing Restaurant" : "Select Different Restaurant",
                              systemImage: "building.2.crop.circle.fill"
                        )
                    }
                }
                
                ThemedButton(.save) {
                    withAnimation { updateRestaurant() }
                }
            }
        }
        .navigationTitle("Create Receipt")
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
    
    @FocusState var focused: CreateRestaurantFocus?
    
    var body: some View {
        Section {
            TextFieldHStack(rs: "Restaurant Name", ls: $restaurantData.name)
                .focused($focused, equals: .name)
            
            TextFieldHStack(rs: "Address 1", ls: $restaurantData.address1)
                .focused($focused, equals: .add1)
            
            TextFieldHStack(rs: "Address 2", ls: $restaurantData.address2)
                .focused($focused, equals: .add2)
            
            TextFieldHStack(rs: "City", ls: $restaurantData.city)
                .focused($focused, equals: .city)
            
            TextFieldHStack(rs: "State", ls: $restaurantData.state)
                .focused($focused, equals: .state)
            
            TextFieldHStack(rs: "ZIP", ls: $restaurantData.zip)
                .keyboardType(.numberPad)
                .focused($focused, equals: .zip)
            
            TextFieldHStack(rs: "Website", ls: $restaurantData.website)
                .keyboardType(.URL)
                .focused($focused, equals: .website)
            
            TextFieldHStack(rs: "Phone", ls: $restaurantData.phone)
                .keyboardType(.phonePad)
                .focused($focused, equals: .phone)
            
            //Toolbar is placed within parent because when applied to parent Section, the toolbar items duplicate
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    KeyboardButton(disabled: focused == .name, navigation: .previous) {
                        switchFocus(.previous)
                    }
                    
                    KeyboardButton(disabled: focused == .phone, navigation: .next) {
                        switchFocus(.next)
                    }
                    
                    ThemedButton(.done) {
                        focused = nil
                    }
                }
            }
        }
    }
    
    func switchFocus(_ direction: KeyboardButton.NavigationOptions) {
        switch focused {
        case .name:
            switch direction {
            case .next:
                focused = .add1

            case .previous:
                focused = nil
            }

        case .add1:
            switch direction {
            case .next:
                focused = .add2

            case .previous:
                focused = .name
            }

        case .add2:
            switch direction {
            case .next:
                focused = .city

            case .previous:
                focused = .add1
            }

        case .city:
            switch direction {
            case .next:
                focused = .state

            case .previous:
                focused = .add2
            }

        case .state:
            switch direction {
            case .next:
                focused = .zip

            case .previous:
                focused = .city
            }

        case .zip:
            switch direction {
            case .next:
                focused = .website

            case .previous:
                focused = .state
            }

        case .website:
            switch direction {
            case .next:
                focused = .phone

            case .previous:
                focused = .zip
            }

        case .phone:
            switch direction {
            case .next:
                focused = nil

            case .previous:
                focused = .website
            }

        case .none:
            focused = nil
        }
    }
    
    enum CreateRestaurantFocus {
        case name, add1, add2, city, state, zip, website, phone
    }
}

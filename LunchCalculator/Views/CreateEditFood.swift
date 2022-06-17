//
//  CreateEditFood.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct CreateEditFood: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var person: People
    let editMode: Bool
    var food: Food?
    
    @State private var name: String = ""
    @State private var price: String = "0"
    @State private var tax: String = "0"
    @State private var fees: String = "0"
    @State private var tip: String = "0"
    
    @State private var showingQCAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    /// This initializer is used when creating a new Food Object
    /// - Parameter person: The person who purchased the food
    init(_ person: Binding<People>) {
        _person = person
        editMode = false
    }
    
    init(_ person: Binding<People>, food: Binding<Food>) {
        _person = person
        _name = State(wrappedValue: food.name.wrappedValue)
        _price = State(wrappedValue: String(food.subtotal.wrappedValue))
        _tax = State(wrappedValue: String(food.tax.wrappedValue))
        _fees = State(wrappedValue: String(food.fees.wrappedValue))
        _tip = State(wrappedValue: String(food.tip.wrappedValue))
        self.food = food.wrappedValue
        editMode = true
    }
    
    var body: some View {
        Form {
            Section {
                TextFieldHStack(rs: "Food Name:", ls: $name)
                TextFieldHStack(rs: "Price:", ls: $price)
                TextFieldHStack(rs: "Tax:", ls: $tax)
                TextFieldHStack(rs: "Tip:", ls: $tip)
                TextFieldHStack(rs: "Service Fees:", ls: $fees)
            }
            
            Button {
                createFood()
            } label: {
                Label("Save Food", image: "plus.circle")
            }
        }
        .alert(alertTitle, isPresented: $showingQCAlert) {
            Button {
                //
            } label: {
                Text("Okay")
            }

        } message: {
            Text(alertMessage)
        }

    }
    
    func QCInput() -> Bool {
        if name == "" {
            alertTitle = "Provide Food Name"
            alertMessage = "Please provide a name for this item."
            showingQCAlert = true
            return false
        }
        
        if price == "" || !QCNumberIsDouble(price) {
            alertTitle = "Provide Price"
            alertMessage = "Please input the price of this item or enter 0 if this item is free."
            showingQCAlert = true
            return false
        }
        
        if tax == "" || !QCNumberIsDouble(tax) {
            alertTitle = "Provide Tax"
            alertMessage = "Please input the tax amount for this item or enter 0 if you are not charging tax."
            showingQCAlert = true
            return false
        }
        
        if fees == "" || !QCNumberIsDouble(fees) {
            alertTitle = "Were there extra service fees?"
            alertMessage = "Please input the price of service fees or enter 0 if there were none."
            showingQCAlert = true
            return false
        }
        
        if tip == "" || !QCNumberIsDouble(tip) {
            alertTitle = "Was there a tip?"
            alertMessage = "Please input the price of the tip or enter 0 if there was no tip."
            showingQCAlert = true
            return false
        }
        
        return true
    }
    
    func QCNumberIsDouble(_ str: String) -> Bool {
        if Double(str) == nil {
            return false
        } else {
            return true
        }
    }
    
    func createFood() {
        if QCInput() {
            if editMode {
                if let foodIndex = person.food.firstIndex(where: {$0.id == food!.id}) {
                    person.food[foodIndex].name = name
                    person.food[foodIndex].subtotal = Double(price)!
                    person.food[foodIndex].tax = Double(tax)!
                    person.food[foodIndex].tip = Double(tip)!
                    person.food[foodIndex].fees = Double(fees)!
                }
            } else {
                let newFood = Food(
                    name: name,
                    subtotal: Double(price)!,
                    tax: Double(tax)!,
                    tip: Double(tip)!,
                    fees: Double(fees)!
                )
                
                person.food.append(newFood)
            }
            
            dismiss()
        }
    }
}

//
//  ContentView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var people: [People] = []
    @State private var showingAddPerson = false
    @State private var showingAddFood = false

    @State private var selectedPersonIndex: Int = 0
    
    var body: some View {
        Form {
            ForEach(people) { person in
                Section {
                    HStack {
                        Text(person.name)
                            .font(.title)
                            .bold()
                        Spacer()
                        Text("Total Due: \(person.food.reduce(0) { $0 + $1.total }, specifier: "%.2f")")
                            .bold()
                    }
                    
                    ForEach(person.food) { food in
                        VStack(alignment: .leading) {
                            Text("Item: \(food.name)")
                                .font(.title3)
                            
                            Text("  Price: $\(food.tax, specifier: "%.2f")")
                            Text("  Price: $\(food.tip, specifier: "%.2f")")
                            Text("  Price: $\(food.fees, specifier: "%.2f")")
                            Text("  Subtotal: $\(food.subtotal, specifier: "%.2f")")
                                .italic()
                        }
                        .font(.subheadline)
                        
                    }
                    
                    Button {
                        if let index = people.firstIndex(where: {$0.id == person.id}) {
                            selectedPersonIndex = index
                            showingAddFood = true
                        }
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                
            }
            
            Button {
                showingAddPerson = true
            } label: {
                Label("Add Person", systemImage: "person.crop.circle.fill.badge.plus")
            }
        }
        .sheet(isPresented: $showingAddPerson) {
            CreatePersonView(people: $people)
        }
        .sheet(isPresented: $showingAddFood) {
            CreateEditFood($people[selectedPersonIndex])
        }
    }
}

struct CreatePersonView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var people: [People]
    @State private var name: String = ""
    @State private var showingQCAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            TextFieldHStack(rs: "Name", ls: $name)
            
            Button {
                createPerson()
            } label: {
                Label("Save", systemImage: "person.crop.circle.fill.badge.plus")
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
            alertTitle = "Please Provide a Name"
            alertMessage = "Creating a person without a name is generally considered cruel and unusual. Please provide a name for this new person. This helps you more than it does me."
            showingQCAlert = true
            return false
        }
        
        return true
    }
    
    func createPerson() {
        if QCInput() {
            let newPerson = People(name: name, food: [])
            people.append(newPerson)
            dismiss()
        }
    }
}

struct CreateEditFood: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var person: People
    
    @State private var name: String = ""
    @State private var price: String = "0"
    @State private var tax: String = "0"
    @State private var fees: String = "0"
    @State private var tip: String = "0"
    
    @State private var showingQCAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    init(_ person: Binding<People>) {
        _person = person
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
            let newFood = Food(
                name: name,
                subtotal: Double(price)!,
                tax: Double(tax)!,
                tip: Double(tip)!,
                fees: Double(fees)!
            )
            
            person.food.append(newFood)
            dismiss()
        }
    }
}

struct People: Identifiable {
    let id = UUID()
    var name: String
    var food: [Food]
}

struct Food: Identifiable {
    let id = UUID()
    var name: String
    var subtotal: Double
    var tax: Double
    var tip: Double
    var fees: Double
    
    var total: Double {
        subtotal + tax + tip + fees
    }
}

struct TextFieldHStack: View {
    var rs: LocalizedStringKey
    @Binding var ls: String
    
    var body: some View {
        HStack {
            Text(rs)
            TextField(rs, text: $ls)
        }
    }
}

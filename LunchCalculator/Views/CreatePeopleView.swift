//
//  CreatePersonView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

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

//
//  CreatePersonView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation

extension CreatePersonView {
    class CreatePersonView_Model: ObservableObject {
        var dc: DataController
        
        var person: Person?
        
        @Published var name: String = ""
        
        @Published var showingQCAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        init(dc: DataController, person: Person? = nil) {
            self.dc = dc
            self.person = person
            
            if person != nil {
                _name = Published(wrappedValue: person!.name)
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
                let personData = PersonData(name: name)
                
                dc.createEditPerson(person, personData: personData)            
            }
        }
    }
}

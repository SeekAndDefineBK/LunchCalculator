//
//  CreatePersonView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation
import SwiftUI

extension CreatePersonView {
    class CreatePersonView_Model: ObservableObject {
        var dc: DataController
        
        var person: Person?
        @Binding var onDisplay: Bool
        
        @Published var personData = PersonData.blank
        
        @Published var showingQCAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
    
        init(dc: DataController, person: Person? = nil, onDisplay: Binding<Bool>) {
            self.dc = dc
            self.person = person
            _onDisplay = onDisplay
            
            if person != nil {
                _personData = Published(wrappedValue: PersonData(
                    name: person!.name,
                    subreceipt: person!.allSubreceipts)
                )
            }
        }
        
        func QCInput() -> Bool {
            if personData.name == "" {
                alertTitle = "Please Provide a Name"
                alertMessage = "Creating a person without a name is generally considered cruel and unusual. Please provide a name for this new person. This helps you more than it does me."
                showingQCAlert = true
                return false
            }
            
            return true
        }
    }
}

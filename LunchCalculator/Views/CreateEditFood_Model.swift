//
//  CreateEditFood_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation
import SwiftUI

extension CreateEditFood {
    class CreateEditFood_Model: ObservableObject {
        var dc: DataController
        
        var person: Person
        let editMode: Bool
        var food: Food?
        
        @Published var foodData: FoodData
        
        @Published var showingDeleteAlert = false
        
        @Published var showingOptionalQC = false
        @Published var showingQCAlert = false
        
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        @Published var alertAction: () = ()
        
        init(dc: DataController, person: Person, food: Food?) {
            self.dc = dc
            self.person = person
            
            if food == nil {
                editMode = false
                _foodData = Published(wrappedValue: FoodData.blank())
                foodData.person = person

            } else {
                editMode = true
                self.food = food
                _foodData = Published(wrappedValue: FoodData(
                        name: food!.name,
                        subtotal: food!.cd_subtotal,
                        person: person,
                        subreceipt: food!.subreceipt
                    )
                )
            }
        }

        func QCInput() -> Bool {
            if foodData.name == "" {
                alertTitle = "Provide Food Name"
                alertMessage = "Please provide a name for this item."
                showingQCAlert = true
                return false
            }
            
            if foodData.subtotal <= 0 {
                alertTitle = "Provide Price"
                alertMessage = "Please input the price of this item or enter 0 if this item is free."
                showingQCAlert = true
                return false
            }

            return true
        }
        
        func createFood(action: () -> Void) {
            if QCInput() {
                dc.createSingleEditFood(food, foodData: foodData)
                action()
            }
        }
    }
}

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
        @Published var allFood: [Food]
        @ObservedObject var subreceipt: Subreceipt
                
        @Published var showingDeleteAlert = false
        @Published var deleteAction: () = ()

        @Published var showingOptionalQC = false
        @Published var showingQCAlert = false
        
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        init(dc: DataController, person: Person, allFood: [Food], subreceipt: Subreceipt) {
            self.dc = dc
            self.person = person
            self.subreceipt = subreceipt
            _allFood = Published(wrappedValue: allFood)
            
            
            if allFood.isEmpty {
                var foodData = FoodData.blank()
                foodData.person = person
                let newFood = dc.createEditSingleFood(nil, foodData: foodData, subreceipt: subreceipt)
                
                self.allFood.append(newFood)
            }
        }
        
        func addNewFood() {
            var foodData = FoodData.blank()
            foodData.person = person
            
            let newFood = dc.createEditSingleFood(nil, foodData: foodData, subreceipt: subreceipt)
            
            allFood.append(newFood)
            
        }
    }
}

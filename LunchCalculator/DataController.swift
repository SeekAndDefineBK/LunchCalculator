//
//  DataController.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import CoreData
import SwiftUI
import CoreSpotlight

class DataController: ObservableObject {
    let injectionTest = "Data Controller is Present"
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "main", managedObjectModel: Self.model)
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file")
        }
        
        return managedObjectModel
    }()
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        save()
    }
    
    func combinedCreation(personData: PersonData, foodData: [FoodData], receipt: Receipt?, restaurant: Restaurant) {
        let newPerson = createEditPerson(nil, personData: personData)
        
        for i in foodData {
            let newFood = createEditFood(nil, foodData: i)
            newFood.person = newPerson
        }
        
        if receipt == nil {
            let receiptData = ReceiptData(restaurant: restaurant, date: Date(), fees: 0, tax: 0, tip: 0)
            
            let newReceipt = createEditReceipt(receipt, receiptData: receiptData, restaurant: restaurant)
            
            updateReceipt(newReceipt)
        } else {
            updateReceipt(receipt!)
        }
        
        func updateReceipt(_ inputReceipt: Receipt) {
            if foodData.isEmpty {
                addPersonToReceipt(newPerson, receipt: inputReceipt)
            } else {
                createEditSubreceipt(subreceipt: nil, food: newPerson.allFood, person: newPerson, receipt: inputReceipt)
            }
        }
        
        save()
    }
    
    func createEditRestaurant(_ restaurant: Restaurant?, restaurantData: RestaurantData) -> Restaurant {
        var output = restaurant
        
        if restaurant == nil {
            let newRestaurant = Restaurant(context: container.viewContext)
            updateData(newRestaurant)
            output = newRestaurant
        } else {
            updateData(restaurant!)
            output = restaurant
        }
        
        func updateData(_ updateObject: Restaurant) {
            updateObject.cd_name = restaurantData.name
            updateObject.cd_address1 = restaurantData.address1
            updateObject.cd_address2 = restaurantData.address2
            updateObject.cd_city = restaurantData.city
            updateObject.cd_state = restaurantData.state
            updateObject.cd_zip = restaurantData.zip
            updateObject.cd_phone = restaurantData.phone
            updateObject.cd_website = restaurantData.website
            
            save()
        }
        
        return output!
    }
    
    func createEditReceipt(_ receipt: Receipt?, receiptData: ReceiptData, restaurant: Restaurant) -> Receipt {
        var output = receipt //this is required because Xcode doesn't want to return from within an if statement
        
        if receipt == nil {
            let newReceipt = Receipt(context: container.viewContext)
            updateData(newReceipt)
            output = newReceipt
        } else {
            updateData(receipt!)
        }

        func updateData(_ updateObject: Receipt) {
            updateObject.cd_date = receiptData.date
            updateObject.cd_fees = receiptData.fees
            updateObject.cd_tax = receiptData.tax
            updateObject.cd_tip = receiptData.tip
            
            updateObject.restaurant = restaurant

            //Save needs to occur here to guarantee the return value is updated
            save()
        }
        
        return output! //This is expected to be not nil because it will be assigned newReceipt in if statement, or it was never nil in the first place
    }
    
    func createEditPerson(_ person: Person?, personData: PersonData) -> Person {
        var output = person
        
        if person == nil {
            let newPerson = Person(context: container.viewContext)
            updateData(newPerson)
            output = newPerson
        } else {
            updateData(person!)
        }
        
        func updateData(_ updateObject: Person) {
            updateObject.id = UUID()
            updateObject.cd_name = personData.name
            save()
        }
        
        return output!
    }
    
    private func createEditFood(_ food: Food?, foodData: FoodData) -> Food {
        var output = food

        if food == nil {
            let newFood = Food(context: container.viewContext)
            updateData(newFood)
            output = newFood
        } else {
            updateData(food!)
        }

        func updateData(_ updateObject: Food) {
            updateObject.cd_name = foodData.name
            updateObject.cd_subtotal = foodData.subtotal
            updateObject.id = UUID()

            updateObject.person = foodData.person

            save()
        }

        return output!
    }
    
    func createEditSingleFood(_ food: Food?, foodData: FoodData, subreceipt: Subreceipt) {
        if food == nil {
            let newFood = Food(context: container.viewContext)
            updateData(newFood)

        } else {
            updateData(food!)
        }
        
        func updateData(_ updateObject: Food) {
            updateObject.cd_name = foodData.name
            updateObject.cd_subtotal = foodData.subtotal
            
            updateObject.id = UUID()
            
            updateObject.person = foodData.person
            updateObject.subreceipt = subreceipt
        }
        save()
    }
    
    private func createEditSubreceipt(subreceipt: Subreceipt?, food: [Food], person: Person, receipt: Receipt) {
        if subreceipt == nil {
            let newSubreceipt = Subreceipt(context: container.viewContext)
            updateData(newSubreceipt)
        } else {
            updateData(subreceipt!)
        }
        
        func updateData(_ updateObject: Subreceipt) {
            updateObject.person = person
            updateObject.receipt = receipt
            for i in food {
                i.subreceipt = updateObject
            }
        }
        
        save()
    }
    
    func addPersonToReceipt(_ person: Person, receipt: Receipt) {
        let newSubreceipt = Subreceipt(context: container.viewContext)
        
        newSubreceipt.receipt = receipt
        newSubreceipt.person = person
        
        save()
    }
}

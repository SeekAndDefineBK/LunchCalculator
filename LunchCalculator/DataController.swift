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
    
//    static var preview: DataController = {
//        let dataController = DataController(inMemory: true)
//        let viewContext = dataController.container.viewContext
//
//        do {
//            try dataController.createSampleData()
//        } catch {
//            fatalError("Fatal error creating preview: \(error.localizedDescription)")
//        }
//
//        return dataController
//    }()
    
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
    
    func combinedCreation(personData: PersonData, foodData: [FoodData], receipt: Receipt?) {
        let newPerson = createEditPerson(nil, personData: personData)
        
        for i in foodData {
            let newFood = createEditFood(nil, foodData: i)
            newFood.person = newPerson
        }
        
        if receipt == nil {
            let newReceipt = createEditReceipt(receipt, receiptData: ReceiptData.blank)
            
            for i in newPerson.allFood {
                createEditSubreceipt(food: i, person: newPerson, receipt: newReceipt)
            }
        }
        
        save()
    }
    
    func createEditReceipt(_ receipt: Receipt?, receiptData: ReceiptData) -> Receipt {
        var output = receipt //this is required because Xcode doesn't want to return from within an if statement
        
        if receipt == nil {
            let newReceipt = Receipt(context: container.viewContext)
            updateData(newReceipt)
            output = newReceipt
        } else {
            updateData(receipt!)
        }

        func updateData(_ updateObject: Receipt) {
            updateObject.cd_address1 = receiptData.address1
            updateObject.cd_address2 = receiptData.address2
            updateObject.cd_city = receiptData.city
            updateObject.cd_state = receiptData.state
            updateObject.cd_zip = receiptData.zip
            updateObject.cd_phone = receiptData.phone
            updateObject.cd_website = receiptData.website
            updateObject.cd_date = receiptData.date
            updateObject.cd_restaurant = receiptData.restaurant

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
    
    func createEditFood(_ food: Food?, foodData: FoodData) -> Food {
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
    
    func createSingleEditFood(_ food: Food?, foodData: FoodData) {
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
            
        }
        save()
    }
    
    private func createEditSubreceipt(food: Food, person: Person, receipt: Receipt) {
        if food.subreceipt == nil {
            let newSubreceipt = Subreceipt(context: container.viewContext)
            updateData(newSubreceipt)
        } else {
            updateData(food.subreceipt!)
        }
        
        func updateData(_ updateObject: Subreceipt) {
            updateObject.person = person
            updateObject.receipt = receipt
            //Is this necessary?
            food.subreceipt = updateObject
        }
        
        save()
    }
}

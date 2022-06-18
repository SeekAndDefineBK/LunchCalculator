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
    
    func createEditPerson(_ person: Person?, personData: PersonData) {
        if person == nil {
            let newPerson = Person(context: container.viewContext)
            updateData(newPerson)
        } else {
            updateData(person!)
        }
        
        func updateData(_ updateObject: Person) {
            updateObject.cd_name = personData.name
        }
        
        save()
    }
    
    func createEditFood(_ food: Food?, foodData: FoodData) {
        if food == nil {
            let newFood = Food(context: container.viewContext)
            updateData(newFood)
        } else {
            updateData(food!)
        }
        
        func updateData(_ updateObject: Food) {
            updateObject.cd_name = foodData.name
            updateObject.cd_subtotal = foodData.subtotal
            updateObject.cd_tax = foodData.tax
            updateObject.cd_tip = foodData.tip
            updateObject.cd_fees = foodData.fees
            
            updateObject.person = foodData.person
            
//            var receipt: Receipt {
//                foodData.subreceipt?.receipt ?? createEditReceipt(nil, receiptData: ReceiptData.blank)
//            }
//
//            createEditSubreceipt(food: updateObject, person: foodData.person, receipt: receipt)
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

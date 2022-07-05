//
//  FoodContainerView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/4/22.
//

import Foundation
import CoreData

extension FoodContainerView {
    class FoodContainerView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
        
        var dc: DataController
        var displayName: String = ""
        
        private let FoodController: NSFetchedResultsController<Food>
        @Published var allFood = [Food]()
        @Published var totalSpent: Double = 0
        @Published var allRestaurants = [Restaurant]()
        @Published var allPeople = [Person]()

        init(dc: DataController, predicateStr: String) {
            self.dc = dc
            
            var predicate: NSPredicate {
                //Create an if statement here if you need this to be more complex
                return NSPredicate(format: "cd_name == %@", predicateStr)
            }
            
            let request: NSFetchRequest<Food> = Food.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Food.cd_name, ascending: true)]
            request.predicate = predicate
            
            FoodController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dc.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            FoodController.delegate = self
            
            do {
                try FoodController.performFetch()
                allFood = FoodController.fetchedObjects ?? []
                updateTotalSpent()
                updateRestaurants()
                updatePeople()
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
            
            if !allFood.isEmpty {
                displayName = allFood[0].name
            } else {
                displayName = "Failed to load name"
            }
            
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newFood = controller.fetchedObjects as? [Food] {
                allFood = newFood
                updateTotalSpent()
                updateRestaurants()
                updatePeople()
            }
        }
        
        func updateTotalSpent() {
            totalSpent = allFood.reduce(0) {$0 + $1.total}
        }
        
        func updateRestaurants() {
            for i in allFood {
                if !allRestaurants.contains(where: {i.restaurant == $0}) {
                    if let restaurant = i.restaurant {
                        allRestaurants.append(restaurant)
                    }
                }
            }
        }
        
        func updatePeople() {
            for i in allFood {
                if !allPeople.contains(where: {i.person == $0}) {
                    if let person = i.person {
                        allPeople.append(person)
                    }
                }
            }
        }
    }
}


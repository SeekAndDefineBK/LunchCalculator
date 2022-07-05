//
//  SingleRestaurantView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/4/22.
//

import Foundation
import CoreData

extension SingleRestaurantView {
    class SingleRestaurantView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
        
        var dc: DataController
        var restaurant: Restaurant
        
        private let FoodController: NSFetchedResultsController<Food>
        @Published var allFood = [Food]()
        
        @Published var showingDeleteAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""

        init(dc: DataController, restaurant: Restaurant) {
            self.dc = dc
            self.restaurant = restaurant
            
            var predicate: NSPredicate {
                return NSPredicate(value: true)
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
                let fetchedFood = FoodController.fetchedObjects ?? []
                
                updateAllFood(fetchedFood)
                
                
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let fetchedFood = controller.fetchedObjects as? [Food] {
                updateAllFood(fetchedFood)
            }
        }
        
        func updateAllFood(_ fetchedFood: [Food]) {
            for i in fetchedFood {
                if i.restaurant == restaurant && !allFood.contains(where: {$0 == i}){
                    allFood.append(i)
                }
            }
        }
        
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let food = allFood[offset]
                dc.delete(food)
            }
        }
        
        func showDeleteAlert() {
            alertTitle = "Delete \(restaurant.name)?"
            alertMessage = "Are you sure you want to delete \(restaurant.name)? This cannot be undone."
            showingDeleteAlert = true
        }
    }
}


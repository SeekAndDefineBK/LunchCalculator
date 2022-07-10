//
//  AllFoodView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import Foundation
import CoreData

extension AllFoodView {
    class AllFoodView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
        
        var dc: DataController
        
        private let FoodController: NSFetchedResultsController<Food>
        @Published var allFood = [Food]()
        @Published var allRestaurants = [Restaurant]()
        @Published var allFoodContainers = [FoodContainer]()

        init(dc: DataController) {
            self.dc = dc
            
            var predicate: NSPredicate {
                //Create an if statement here if you need this to be more complex
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
                allFood = FoodController.fetchedObjects ?? []
                
                for i in allFood {
                    if let restaurant = i.restaurant {
                        if !allRestaurants.contains(restaurant) {
                            allRestaurants.append(restaurant)
                        }
                    }
                    
                    if !allFoodContainers.contains(where: {$0.rawName == i.rawName}) {
                        let newFoodContainer = FoodContainer(i)
                        allFoodContainers.append(newFoodContainer)
                    }
                    
                }
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newFood = controller.fetchedObjects as? [Food] {
                allFood = newFood
                
                for i in allFood {
                    if let restaurant = i.restaurant {
                        if !allRestaurants.contains(restaurant) {
                            allRestaurants.append(restaurant)
                        }
                    }
                }
            }
        }
    }
}

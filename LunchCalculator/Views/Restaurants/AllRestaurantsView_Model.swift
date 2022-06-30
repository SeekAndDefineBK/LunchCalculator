//
//  AllRestaurantsView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/29/22.
//

import Foundation
import CoreData

extension AllRestaurantsView {
    class AllRestaurantsView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
        
        var dc: DataController
        
        private let RestaurantController: NSFetchedResultsController<Restaurant>
        @Published var allRestaurants = [Restaurant]()

        init(dc: DataController) {
            self.dc = dc
            
            var predicate: NSPredicate {
                //Create an if statement here if you need this to be more complex
                return NSPredicate(value: true)
            }
            
            let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Restaurant.cd_name, ascending: true)]
            request.predicate = predicate
            
            RestaurantController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dc.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            RestaurantController.delegate = self
            
            do {
                try RestaurantController.performFetch()
                allRestaurants = RestaurantController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newRestaurants = controller.fetchedObjects as? [Restaurant] {
                allRestaurants = newRestaurants
            }
        }
    }
}

//
//  ContentView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation
import CoreData

extension CreateReceiptView {
    class CreateReceiptView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        var dc: DataController
        
        private let PersonController: NSFetchedResultsController<Person>
        @Published var allPeople = [Person]()
        
        @Published var showingAddPerson = false
        @Published var showingAddFood = false

        @Published var selectedPersonIndex: Int = 0
        @Published var selectedFoodIndex: Int = 0
        @Published var showEditFood = false

        init(dc: DataController) {
            self.dc = dc
            
            var predicate: NSPredicate {
                //Create an if statement here if you need this to be more complex
                return NSPredicate(value: true)
            }
            
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Person.cd_name, ascending: true)]
            request.predicate = predicate
            
            PersonController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dc.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            PersonController.delegate = self
            
            do {
                try PersonController.performFetch()
                allPeople = PersonController.fetchedObjects ?? []
                print(allPeople)
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newPeople = controller.fetchedObjects as? [Person] {
                allPeople = newPeople
            }
        }
    }
}

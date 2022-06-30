//
//  AllPeopleView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import Foundation
import CoreData

extension AllPeopleView {
    class AllPeopleView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
        
        var dc: DataController
        
        private let PeopleController: NSFetchedResultsController<Person>
        @Published var allPeople = [Person]()

        init(dc: DataController) {
            self.dc = dc
            
            var predicate: NSPredicate {
                //Create an if statement here if you need this to be more complex
                return NSPredicate(value: true)
            }
            
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Person.cd_name, ascending: true)]
            request.predicate = predicate
            
            PeopleController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dc.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            PeopleController.delegate = self
            
            do {
                try PeopleController.performFetch()
                allPeople = PeopleController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newPeople = controller.fetchedObjects as? [Person] {
                allPeople = newPeople
            }
        }
        
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let person = allPeople[offset]
                dc.delete(person)
            }
        }
    }
}

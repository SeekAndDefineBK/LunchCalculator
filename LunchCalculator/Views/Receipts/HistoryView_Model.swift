//
//  HistoryView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation
import CoreData

extension HistoryView {
    class HistoryView_Model: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
        
        var dc: DataController
        
        private let ReceiptController: NSFetchedResultsController<Receipt>
        @Published var allReceipts = [Receipt]()
        @Published var showingCreateReceipt = false


        init(dc: DataController) {
            self.dc = dc
            
            var predicate: NSPredicate {
                //Create an if statement here if you need this to be more complex
                return NSPredicate(value: true)
            }
            
            let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Receipt.cd_date, ascending: true)]
            request.predicate = predicate
            
            ReceiptController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dc.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            ReceiptController.delegate = self
            
            do {
                try ReceiptController.performFetch()
                allReceipts = ReceiptController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch locations from ContentView_ViewModel init.")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newReceipts = controller.fetchedObjects as? [Receipt] {
                allReceipts = newReceipts
            }
        }
        
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let receipt = allReceipts[offset]
                dc.delete(receipt)
            }
        }
    }
}

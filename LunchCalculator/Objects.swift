//
//  Objects.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import Foundation
import SwiftUI

extension Receipt {
    var allPeople: [Person] {
        var output = [Person]()
        
        for i in allSubreceipts {
            if i.person != nil {
                output.append(i.person!) //this should always be populated
            }
        }
        
        return output
    }
    
    var allFood: [Food] {
        var output = [Food]()
        
        for i in allSubreceipts {
            output += i.allFood
        }
        
        return output
    }
    
    var allSubreceipts: [Subreceipt] {
        let arr = subreceipts?.allObjects as? [Subreceipt] ?? []
        return arr
    }
    
    var date: Date {
        cd_date ?? Date()
    }
    
    var restaurantName: String {
        restaurant?.name ?? "Warning: Unknown Restaurant"
    }
    
    var title: String {
        "\(restaurantName) on \(date.formatted(date: .numeric, time: .omitted))"
    }
    
    var titleView: Text {
        Text("\(title). Total of $\(total, specifier: "%.2f")")
    }
    
    var subtotal: Double {
        allSubreceipts.reduce(0){ $0 + $1.totalDue }
    }
    
    var total: Double {
        subtotal + cd_fees + cd_tax + cd_tip
    }
}

extension Person {
    var name: String {
        cd_name ?? "Unknown Name"
    }
    
    var allSubreceipts: [Subreceipt] {
        return subreceipts?.allObjects as? [Subreceipt] ?? []
    }
    
    var allFood: [Food] {
        let arr = food?.allObjects as? [Food] ?? []
        return arr.sorted(by: {$0.name < $1.name})
    }
    
    var totalPaid: Text {
        let doubleDue = allSubreceipts.reduce(0){ $0 + $1.totalDue }
        
        return Text("Total Paid: \(doubleDue, specifier: "%.2f")")
    }
}

extension Food {
    var name: String {
        cd_name ?? "Unknown Food Name"
    }
    
    var total: Double {
        cd_subtotal
    }
    
    var date: Date {
        subreceipt?.receipt?.date ?? Date()
    }
    
    var restaurantName: String {
        subreceipt?.receipt?.restaurantName ?? "Unknown Restaurant"
    }
    
    //TODO: Make this less dangerous
    /// Use sparingly, there is a ton of assumptions in this computed property
    var restaurant: Restaurant? {
        subreceipt?.receipt?.restaurant
    }
}

struct FoodContainer: Identifiable {
    var id = UUID()
    var name: String
    var displayName: String {
        if name == "" {
            return "Unknown Foodname"
        } else {
            return name
        }
    }
    var allEntries: [Food]
//    var allRestaurants: [Restaurant]
    
    init(_ newEntry: [Food]) {
        self.allEntries = newEntry
        
        
        var newName: String {
            if newEntry.isEmpty{
                return "Unknown"
            } else {
                return newEntry[0].name
            }
        }
        
        self.name = newName
    }
}

extension Subreceipt {
    var allFood: [Food] {
        let arr = food?.allObjects as? [Food] ?? []
        return arr.sorted(by: {$0.name < $1.name})
    }
    
    var totalDue: Double {
        return allFood.reduce(0) { $0 + $1.total}
    }
    
    var restaurantName: String {
        receipt?.restaurantName ?? "Unknown Restaurant"
    }
}

extension Restaurant {
    var name: String {
        cd_name ?? "Unknown Restuarant Name"
    }
    
    var allReceipts: [Receipt] {
        return receipts?.allObjects as? [Receipt] ?? []
    }
    
    var totalSpent: Double {
        allReceipts.reduce(0) { $0 + $1.total }
    }
    
    var allFood: [Food] {
        var output = [Food]()
        
        for i in allReceipts {
            output += i.allFood
        }
        
        return output
    }
}

struct FoodData: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var subtotal: Double
    var person: Person?
    var subreceipt: Subreceipt?
    
    static func blank() -> FoodData {
        return FoodData(name: "", subtotal: 0.0)
    }
    
//    static var blank = FoodData(
//        id: UUID(),
//        name: "",
//        subtotal: 0.0
//    )
}

struct PersonData {
    var name: String
    var subreceipt: [Subreceipt]?
    
    static var blank = PersonData(
        name: ""
    )
}

struct ReceiptData {
    var restaurant: Restaurant

    var date: Date
    var fees: Double
    var tax: Double
    var tip: Double
    
    //Do not create blank data
}

struct RestaurantData {
    var address1: String = ""
    var address2: String = ""
    var city: String = ""
    var name: String = ""
    var phone: String = ""
    var state: String = ""
    var website: String = ""
    var zip: String = ""
    
    var receipts: [Receipt]?
}

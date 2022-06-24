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
}

extension Food {
    var name: String {
        cd_name ?? "Unknown Food Name"
    }
    
    var total: Double {
        cd_subtotal
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
}

extension Restaurant {
    var name: String {
        cd_name ?? "Unknown Restuarant Name"
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

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
        if cd_name == nil || cd_name == "" {
            return "Unknown Food Name"
        } else {
            return cd_name!
        }
    }
    
    var rawName: String {
        cd_name ?? ""
    }
    
    var personName: String {
        person?.name ?? "Unknown person"
    }
    
    var total: Double {
        cd_subtotal
    }
    
    var totalWithTax: Double {
        total + tax
    }
    
    private var subreceiptPercentage: Double {
        total / (subreceipt?.totalDue ?? 0)
    }
    
    var tax: Double {
        (subreceipt?.splitTaxAmount ?? 0) * subreceiptPercentage
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

/// This is used in tandem with FoodContainerView to merge duplicate Food items into a single view.
///  - id: Allows for Identifiable for ForEach Loop
///  - rawName corresponds to the rawName value on the Food object. Ex this is the CoreData name or "" if nil
///  - displayName is a friendly name displayed for the user
struct FoodContainer: Identifiable {
    var id = UUID()
    var rawName: String
    var displayName: String {
        if rawName == "" {
            return "Unknown Foodname"
        } else {
            return rawName
        }
    }
    
    init(_ food: Food) {
        self.rawName = food.rawName
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
    
    var personName: String {
        person?.name ?? "Unknown Person"
    }
    

    var restaurantName: String {
        receipt?.restaurantName ?? "Unknown Restaurant"
    }
    
    //TODO: Do you need this? Is it better on Food? Or do the calculations on Receipt make these unnecessary?
    var totalWithExtrasDue: Double {
        return totalDue + splitTaxAmount + splitTipAmount + splitFeesAmount
    }

    var billPercentage: Double {
        let receiptTotal = receipt?.total ?? 0

        return totalDue / receiptTotal
    }

    var splitTipAmount: Double {
        return (receipt?.cd_tip ?? 0) * billPercentage
    }

    var splitFeesAmount: Double {
        return (receipt?.cd_fees ?? 0) * billPercentage
    }

    var splitTaxAmount: Double {
        return (receipt?.cd_tax ?? 0) * billPercentage
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

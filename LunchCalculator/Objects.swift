//
//  Objects.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import Foundation

extension Person {
    var name: String {
        cd_name ?? "Unknown Name"
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

struct FoodData: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var subtotal: Double
    var person: Person?
    var subreceipt: Subreceipt?
    
    static var blank = FoodData(
        name: "",
        subtotal: 0.0
    )
}

struct PersonData {
    var name: String
    var subreceipt: Subreceipt?
    
    static var blank = PersonData(
        name: ""
    )
}

struct ReceiptData {
    var restaurant: String
    var address1: String
    var address2: String
    var city: String
    var state: String
    var zip: String
    var phone: String
    var website: String
    var date: Date
    
    static var blank = ReceiptData(
        restaurant: "",
        address1: "",
        address2: "",
        city: "",
        state: "",
        zip: "",
        phone: "",
        website: "",
        date: Date())
}

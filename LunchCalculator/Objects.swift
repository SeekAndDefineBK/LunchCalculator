//
//  Objects.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import Foundation

struct People: Identifiable {
    let id = UUID()
    var name: String
    var food: [Food]
}

struct Food: Identifiable {
    let id = UUID()
    var name: String
    var subtotal: Double
    var tax: Double
    var tip: Double
    var fees: Double
    
    var total: Double {
        subtotal + tax + tip + fees
    }
}

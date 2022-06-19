//
//  LunchCalculatorApp.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

@main
struct LunchCalculatorApp: App {
    @StateObject var dc: DataController
    
    init() {
        let dataController = DataController()
        _dc = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeContainerView(dc: dc)
        }
    }
}

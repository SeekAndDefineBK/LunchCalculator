//
//  Extensions.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/25/22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding {
            self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
            handler()
        }
    }
}

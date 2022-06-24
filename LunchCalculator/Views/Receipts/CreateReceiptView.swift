//
//  CreateReceiptView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import SwiftUI

struct CreateReceiptView: View {
    var dc: DataController
    @State private var receipt: Receipt?
    
    var body: some View {
        if receipt != nil {
            ReceiptView(dc: dc, receipt: receipt!)
        } else {
            Button {
                createReceipt()
            } label: {
                Label("Create New Receipt", systemImage: "sparkles")
            }
        }
    }
    
    func createReceipt() {
        self.receipt = dc.createEditReceipt(nil, receiptData: ReceiptData.blank)
    }
}

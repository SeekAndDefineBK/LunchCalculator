//
//  HistoryView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var vm: HistoryView_Model
    static let tag = "History"
    
    init(dc: DataController) {
        let viewModel = HistoryView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        SelectRestaurantView(dc: vm.dc)
                    } label: {
                        Label("Create Receipt", systemImage: "plus.circle")
                    }
                }
                
                ForEach(vm.allReceipts) { receipt in
                    NavigationLink {
                        //TODO: Is is possible for restaurant to be nil?
                        ReceiptView(dc: vm.dc, receipt: receipt, restaurant: receipt.restaurant!)
                    } label: {
                        Text(receipt.title)
                    }
                }
                .onDelete { offset in
                    vm.delete(offset)
                }
            }
            .navigationTitle("Receipt History")
        }
    }
}

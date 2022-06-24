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
                ForEach(vm.allReceipts) { receipt in
                    NavigationLink {
                        //TODO: Is is possible for restaurant to be nil?
                        ReceiptView(dc: vm.dc, receipt: receipt, restaurant: receipt.restaurant!)
                    } label: {
                        Text(receipt.cd_date?.formatted() ?? Date().formatted())
                    }

                    
                }
                .onDelete { offset in
                    vm.delete(offset)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        vm.showingCreateReceipt = true
                    } label: {
                        Label("Create Receipt", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Receipt History")

            .sheet(isPresented: $vm.showingCreateReceipt) {
                SelectRestaurantView(dc: vm.dc)
            }
        }
    }
}

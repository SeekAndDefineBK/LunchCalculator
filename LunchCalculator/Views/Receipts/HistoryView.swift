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
            ReusableList{
                Group {
                    NavigationLink {
                        SelectRestaurantView(dc: vm.dc)
                    } label: {
                        Label("Create Receipt", systemImage: "plus.circle")
                    }
                    
                    Section(header: Text("All Receipts")) {
                        ForEach(vm.allReceipts) { receipt in
                            NavigationLink {
                                //TODO: Is is possible for restaurant to be nil?
                                ReceiptView(dc: vm.dc, receipt: receipt, restaurant: receipt.restaurant!)
                            } label: {
                                ReceiptCell(receipt: receipt)
                            }

                        }
                        .onDelete { offset in
                            vm.delete(offset)
                        }
                    }
                    
                }
            }
            .navigationTitle("Receipt History")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SelectRestaurantView(dc: vm.dc)
                    } label: {
                        Label("Create Receipt", systemImage: "plus.circle")
                    }
                }
            }
            
        }
    }
}

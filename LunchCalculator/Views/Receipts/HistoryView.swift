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
                                PreviewCell {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(receipt.restaurantName)
                                                .font(.title3)
                                                .bold()
                                                .italic()
                                                                                    
                                            Text("on \(receipt.date.formatted(date: .numeric, time: .omitted))")
                                        }
                                        
                                        HStack {
                                            Text(receipt.allNames)
                                            Spacer()
                                            Text("$\(receipt.total, specifier: "%.2f")")
                                                .bold()
                                                .italic()
                                            
                                        }
                                    }
                                    
                                }
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

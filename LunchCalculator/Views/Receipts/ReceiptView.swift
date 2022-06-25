//
//  ContentView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct ReceiptView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: ReceiptView_Model
    static let tag = "NewReceipt"
    @State private var selectedSubreceipt: Subreceipt?
    @State private var fees: Double = 0
    @State private var tax: Double = 0
    @State private var tip: Double = 0
    
    init(dc: DataController, receipt: Receipt, restaurant: Restaurant) {
        let viewModel = ReceiptView_Model(
            dc: dc,
            receipt: receipt,
            restaurant: restaurant
        )
        
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                Text("Bill: \(vm.receipt.total + tax + tip + fees, specifier: "%.2f")")
                    .bold()
                    .font(.title)
                
                //TODO: Make this persist, create subview with onChange modifiers
                DoubleFieldHStack(rs: "Tax:", ls: $tax)
                DoubleFieldHStack(rs: "Tip:", ls: $tip)
                DoubleFieldHStack(rs: "Service Fees:", ls: $fees)
            }
            
            ForEach(vm.receipt.allSubreceipts) { subreceipt in
                Section {
                    HStack {
                        Text(subreceipt.person!.name)
                            .font(.title)
                            .bold()
                        Spacer()
                        Text("Total Due: \(calculateSplit(subreceipt), specifier: "%.2f")")
                            .bold()
                    }
                    
                    ForEach(subreceipt.allFood) { food in
                        NavigationLink {
                            CreateEditFood(dc: vm.dc, person: subreceipt.person!, food: food, subreceipt: subreceipt)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Item: \(food.name)")
                                    .font(.title3)

                                VStack(alignment: .leading) {
                                    Text("Menu Price: $\(food.cd_subtotal, specifier: "%.2f")")
                                    Text("Subtotal: \(food.total, specifier: "%.2f")")
                                        .italic()
                                        .bold()
                                }
                                .padding(.leading, 10)
                                
                            }
                            .font(.subheadline)
                        }
                    }
                    
                    Button {
                        if let index = vm.receipt.allPeople.firstIndex(where: {$0.id == subreceipt.person!.id}) {
                            vm.selectedPersonIndex = index
                            selectedSubreceipt = subreceipt
                            vm.showingAddFood = true
                        }
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
            }
            
            Button {
                vm.showingAddPerson = true
                
            } label: {
                Label("Add Person", systemImage: "person.crop.circle.fill.badge.plus")
            }
            
            Button {
                vm.askToDelete()
            } label: {
                Label("Delete Receipt", systemImage: "x.square.fill")
            }
            .foregroundColor(.red)

        }
        .navigationTitle(vm.restaurant.name)
        .sheet(isPresented: $vm.showingAddPerson) {
            SelectPersonView(dc: vm.dc, receipt: vm.receipt, restaurant: vm.restaurant)
        }
        .sheet(isPresented: $vm.showingAddFood) {
            CreateEditFood(
                dc: vm.dc,
                person: vm.receipt.allPeople[vm.selectedPersonIndex], subreceipt: selectedSubreceipt!
            )
        }
        .alert(vm.alertTitle, isPresented: $vm.showingDeleteAlert) {
            
            Button(role: .destructive) {
                vm.dc.delete(vm.receipt)
                dismiss()
            } label: {
                Text("Yes, Delete")
            }

        } message: {
            Text(vm.alertMessage)
        }
    }
    
    func calculateSplit(_ subreceipt: Subreceipt) -> Double {
        let totalExtras = tax + tip + fees
        let percentageOfExtras = subreceipt.totalDue / vm.receipt.total
        
        return subreceipt.totalDue + (totalExtras * percentageOfExtras)
    }
}



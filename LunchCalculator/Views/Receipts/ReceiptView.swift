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
            ReceiptFeesView(receipt: vm.receipt, tax: $vm.tax, tip: $vm.tip, fees: $vm.fees, save: vm.dc.save)
            
            ForEach(vm.receipt.allSubreceipts.sorted(by: {$0.personName < $1.personName})) { subreceipt in
                SubreceiptView(
                    dc: vm.dc,
                    subreceipt: subreceipt,
                    totalDue: vm.calculateSplit(subreceipt),
                    tax: vm.calculateTax(subreceipt),
                    tip: vm.calculateTip(subreceipt),
                    fees: vm.calculateFees(subreceipt)) {
                        //this is assigned to askToRemoveAction
                        vm.askToRemove(subreceipt: subreceipt)
                    }
            }
        
            NavigationLink {
                SelectPersonView(dc: vm.dc, receipt: vm.receipt, restaurant: vm.restaurant)
            } label: {
                Label("Add Person", systemImage: "person.crop.circle.fill.badge.plus")
            }
            
            Button {
                vm.askToDelete()
            } label: {
                Label("Delete Receipt", systemImage: "trash.fill")
            }
            .foregroundColor(.red)

        }
        
        
        .navigationTitle(vm.restaurant.name)
        .alert(vm.alertTitle, isPresented: $vm.showingRemovePersonAlert) {
            
            Button(role: .destructive) {
                withAnimation {
                    vm.removePersonAction()
                }
            } label: {
                Text("Yes, Remove")
            }

        } message: {
            Text(vm.alertMessage)
        }
        .alert(vm.alertTitle, isPresented: $vm.showingDeleteAlert) {
            
            Button(role: .destructive) {
                vm.dc.delete(vm.receipt)
            } label: {
                Text("Yes, Delete")
            }

        } message: {
            Text(vm.alertMessage)
        }
        .onDisappear {
            //TODO: Does this fix bug where Total is not updated immediately on Restaurants tab?
            vm.restaurant.objectWillChange.send()
            vm.receipt.objectWillChange.send()
        }
    }
}

struct ReceiptFeesView: View {
    @ObservedObject var receipt: Receipt
    
    @Binding var tax: Double
    @Binding var tip: Double
    @Binding var fees: Double
    
    let save: () -> Void
    
    @FocusState var focused: ReceiptFeesFocus?
    
    var body: some View {
        Section {
            Text("Bill: \(receipt.subtotal + tax + tip + fees, specifier: "%.2f")")
                .bold()
                .font(.title)
            
            DoubleFieldHStack(rs: "Tax:", ls: $tax.onChange(update))
                .focused($focused, equals: .tax)
            
            DoubleFieldHStack(rs: "Tip:", ls: $tip.onChange(update))
                .focused($focused, equals: .tip)
            
            DoubleFieldHStack(rs: "Service Fees:", ls: $fees.onChange(update))
                .focused($focused, equals: .fees)
            
            //Toolbar is placed within parent because when applied to parent Section, the toolbar items duplicate
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    KeyboardButton(disabled: focused == .tax, navigation: .previous) {
                        switchFocus(.previous)
                    }
                    
                    KeyboardButton(disabled: focused == .fees, navigation: .next) {
                        switchFocus(.next)
                    }
                    
                    Button {
                        focused = nil
                    } label: {
                        Label("Done", systemImage: "checkmark.circle.fill")
                    }
                }
            }
        }
        
    }
    
    func switchFocus(_ direction: KeyboardButton.NavigationOptions) {
        switch focused {
        case .tax:
            switch direction {
            case .previous:
                focused = nil
            case .next:
                focused = .tip
            }
            
        case .tip:
            switch direction {
            case .previous:
                focused = .tax
            case .next:
                focused = .fees
            }
            
        case .fees:
            switch direction {
            case .previous:
                focused = .tip
            case .next:
                focused = nil
            }
            
        case .none:
            focused = nil
        }
    }
    
    func update() {
        receipt.objectWillChange.send()
        
        receipt.cd_tax = tax
        receipt.cd_tip = tip
        receipt.cd_fees = fees
        
        save()
    }
    
    enum ReceiptFeesFocus {
        case tax, tip, fees
    }
}

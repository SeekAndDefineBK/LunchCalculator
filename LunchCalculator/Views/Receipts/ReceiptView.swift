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
            
            ForEach(vm.receipt.allSubreceipts) { subreceipt in
                Section {
                    VStack(alignment: .trailing) {
                        HStack {
                            Text(subreceipt.person!.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            Text("Total Due: \(calculateSplit(subreceipt), specifier: "%.2f")")
                                .bold()
                        }
                    }
                    
                    ForEach(subreceipt.allFood) { food in
                        NavigationLink {
                            CreateEditFood(dc: vm.dc, person: subreceipt.person!, food: subreceipt.allFood, subreceipt: subreceipt)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Item: \(food.name)")
                                    .font(.title3)

                                Text("Menu Price: $\(food.cd_subtotal, specifier: "%.2f")")
                                    .italic()
                                    .padding(.leading, 10)
                            }
                            .font(.subheadline)
                        }
                    }
                    
                    Group {
                        if vm.tax != 0 {
                            Text("Tax: $\(calculateTax(subreceipt), specifier: "%.2f")")
                        }
                        
                        if vm.tip != 0 {
                            Text("Tip: $\(calculateTip(subreceipt), specifier: "%.2f")")
                        }
                        
                        if vm.fees != 0 {
                            Text("Service Fees: $\(calculateFees(subreceipt), specifier: "%.2f")")
                        }
                    }
                    .font(.subheadline)
                    .padding(.leading, 10)

                    
                    NavigationLink {
                        CreateEditFood(dc: vm.dc, person: subreceipt.person!, food: subreceipt.allFood, subreceipt: subreceipt)
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
                Label("Delete Receipt", systemImage: "trash.fill")
            }
            .foregroundColor(.red)

        }
        .navigationTitle(vm.restaurant.name)
        .sheet(isPresented: $vm.showingAddPerson) {
            SelectPersonView(dc: vm.dc, receipt: vm.receipt, restaurant: vm.restaurant)
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
        .onDisappear {
            //TODO: Does this fix bug where Total is not updated immediately on Restaurants tab?
            vm.restaurant.objectWillChange.send()
            vm.receipt.objectWillChange.send()
        }
    }
    
    func calculateSplit(_ subreceipt: Subreceipt) -> Double {
        let tax = calculateTax(subreceipt)
        let tip = calculateTip(subreceipt)
        let fees = calculateFees(subreceipt)
        
        return subreceipt.totalDue + tax + tip + fees
    }
    
    func calculateTip(_ subreceipt: Subreceipt) -> Double {
        let percentageOfTip = subreceipt.totalDue / vm.receipt.subtotal
        
        return vm.tip * percentageOfTip
    }
    
    func calculateTax(_ subreceipt: Subreceipt) -> Double {
        let percentageOfTax = subreceipt.totalDue / vm.receipt.subtotal
        
        return vm.tax * percentageOfTax
    }
    
    func calculateFees(_ subreceipt: Subreceipt) -> Double {
        let percentageOfFees = subreceipt.totalDue / vm.receipt.subtotal
        
        return vm.fees * percentageOfFees
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

//
//  CreatePersonView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/17/22.
//

import SwiftUI

struct CreatePersonView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: CreatePersonView_Model
    
    init(dc: DataController, person: Person? = nil, receipt: Receipt, restaurant: Restaurant, onSaveAction: @escaping () -> Void) {
        let viewModel = CreatePersonView_Model(dc: dc, person: person, onSaveAction: onSaveAction)
        _vm = StateObject(wrappedValue: viewModel)
        self.receipt = receipt
        self.restaurant = restaurant
        
        var newFood = FoodData.blank()
        newFood.person = person
    }
    
    private var receipt: Receipt
    private var restaurant: Restaurant
    
    @State private var person: Person?
    @State private var subreceipt: Subreceipt?
    
    var body: some View {
        List {
            Section {
                TextFieldHStack(rs: "Name", ls: $vm.personData.name)
                            
                Button {
                    //TODO: Do not create without a name value
                    if vm.personData.name ==  "" {
                        vm.onSaveAction()
                    } else {
                        withAnimation {
                            person = vm.dc.createEditPerson(nil, personData: vm.personData)
                            vm.personData.name = ""
                        }
                    }
                    
                    
                } label: {
                    Label("Save", systemImage: "plus.circle")
                }

            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showingQCAlert) {
            Button {
                //
            } label: {
                Text("Okay")
            }

        } message: {
            Text(vm.alertMessage)
        }
    }
}

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
    
    init(dc: DataController, person: Person? = nil, receipt: Receipt, restaurant: Restaurant, onDisplay: Binding<Bool>) {
        let viewModel = CreatePersonView_Model(dc: dc, person: person, onDisplay: onDisplay)
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
                    
                ThemedButton(.done) {
                    withAnimation {
                        person = vm.dc.createEditPerson(nil, personData: vm.personData)
                        vm.personData.name = ""
                        vm.onDisplay = false
                    }
                }
                .disabled(vm.personData.name == "")
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showingQCAlert) {
            ThemedButton(.okay) {  }
        } message: {
            Text(vm.alertMessage)
        }
    }
}

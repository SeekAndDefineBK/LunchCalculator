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
    
    init(dc: DataController, person: Person? = nil) {
        let viewModel = CreatePersonView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            TextFieldHStack(rs: "Name", ls: $vm.name)
            
            Button {
                vm.createPerson()
                dismiss()
            } label: {
                Label("Save", systemImage: "person.crop.circle.fill.badge.plus")
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

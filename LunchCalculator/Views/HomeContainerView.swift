//
//  HomeContainerView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import SwiftUI

struct HomeContainerView: View {
    @StateObject var vm: HomeContainerView_Model
    @SceneStorage("tag") var tag: String = "1"
    
    init(dc: DataController) {
        let viewModel = HomeContainerView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView {
            CreateReceiptView(dc: vm.dc)
                .tag(CreateReceiptView.tag)
                .tabItem {
                    Label("New", systemImage: "sparkles")
                }
            
            Text("History")
                .tag("2")
                .tabItem {
                    Label("History", systemImage: "newspaper")
                }
            
            
            Text("Settings")
                .tag("3")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

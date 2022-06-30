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
            HistoryView(dc: vm.dc)
                .tag(HistoryView.tag)
                .tabItem {
                    Label("History", systemImage: "newspaper")
                }
            
            AllPeopleView(dc: vm.dc)
                .tag(AllPeopleView.tag)
                .tabItem {
                    Label("People", systemImage: "person.3.fill")
                }
            
            AllFoodView(dc: vm.dc)
                .tag(AllFoodView.tag)
                .tabItem {
                    Label("Food", systemImage: "leaf")
                }
            
            AllRestaurantsView(dc: vm.dc)
                .tag(AllRestaurantsView.tag)
                .tabItem {
                    Label("Restaurants", systemImage: "building.2.crop.circle.fill")
                }
            
            Text("Settings")
                .tag("3")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

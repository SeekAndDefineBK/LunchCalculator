//
//  HomeContainerView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import SwiftUI
import UIKit

struct HomeContainerView: View {
    @StateObject var vm: HomeContainerView_Model
    @SceneStorage("tag") var tag: String = "1"
    
    let coloredNavAppearance = UINavigationBarAppearance()

    
    init(dc: DataController) {
        let viewModel = HomeContainerView_Model(dc: dc)
        _vm = StateObject(wrappedValue: viewModel)
        
        UITabBar.appearance().isOpaque = false
        
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(Color.mint)
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().tintColor = .white
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
        .accentColor(.mint)
    }
}

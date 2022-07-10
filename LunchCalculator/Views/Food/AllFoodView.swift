//
//  AllFoodView.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/23/22.
//

import SwiftUI

struct AllFoodView: View {
    @StateObject var vm: AllFoodView_Model
    static let tag = "AllFood"

    init(dc: DataController) {
        let viewModel = AllFoodView_Model(
            dc: dc
        )

        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ReusableList {
                Group {
                    ForEach(vm.allFoodContainers) { foodContainer in
                        NavigationLink {
                            FoodContainerView(dc: vm.dc, predicateStr: foodContainer.rawName)
                        } label: {
                            FoodContainerCell(food: foodContainer)
                        }
                    }
                }
            }

            .navigationTitle("All Food")
        }
    }
}

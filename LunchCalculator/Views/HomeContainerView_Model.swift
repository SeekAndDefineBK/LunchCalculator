//
//  HomeContainerView_Model.swift
//  LunchCalculator
//
//  Created by Brett Koster on 6/18/22.
//

import Foundation
extension HomeContainerView {
    class HomeContainerView_Model: ObservableObject {
        var dc: DataController
        
        init(dc: DataController) {
            self.dc = dc
        }
    }
}

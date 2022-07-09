//
//  Buttons.swift
//  LunchCalculator
//
//  Created by Brett Koster on 7/8/22.
//

import SwiftUI


struct ThemedButton: View {
    enum ButtonType: String {
        case addFood, addPerson, delete, deleteReceipt, deleteRestaurant, deletePerson, deleteFood, removePerson, okay, cancel, done, destructive, save, saveFood, createPerson
        
        var displayText: String {
            switch self {
            case .addFood:
                return NSLocalizedString("Add Food", comment: "Creating a new food entry.")
            case .delete:
                return NSLocalizedString("Delete", comment: "Confirming action to proceed with deleting an object.")
            case .removePerson:
                return NSLocalizedString("Yes, Remove", comment: "Confirming action to remove a person from a receipt or Food.")
            case .okay:
                return NSLocalizedString("Okay", comment: "No options given, proceed.")
            case .cancel:
                return NSLocalizedString("Cancel", comment: "Cancel editing text, do not save.")
            case .done:
                return NSLocalizedString("Done", comment: "Done editing text.")
            case .destructive:
                return NSLocalizedString("Yes, Delete", comment: "Confirming the user would like to proceed with deleting an object.")
            case .addPerson:
                return NSLocalizedString("Add Person", comment: "Adding a new person into the app.")
            case .deleteReceipt:
                return NSLocalizedString("Delete Receipt", comment: "Delete's a selected Receipt and entirely removes them from the app.")
            case .deletePerson:
                return NSLocalizedString("Delete Person", comment: "Delete's a selected Person and entirely removes them from the app.")
            case .deleteFood:
                return NSLocalizedString("Delete Food", comment: "Delete's a selected Food and entirely removes them from the app.")
            case .deleteRestaurant:
                return NSLocalizedString("Delete Restaurant", comment: "Delete's a selected Restaurant and entirely removes them from the app.")
            case .save:
                return NSLocalizedString("Save", comment: "Save and close the text editor.")
            case .saveFood:
                return NSLocalizedString("Save Food", comment: "Creating a new food entry and close the editor.")
            case .createPerson:
                return NSLocalizedString("Create Person", comment: "Creating a new person to use now and in the future.")
            }
        }
        
        var systemImage: String {
            switch self {
            case .addFood, .save, .saveFood:
                return "plus.circle"
            case .delete, .deleteReceipt, .deletePerson, .deleteFood, .deleteRestaurant:
                return "trash.fill"
            case .removePerson:
                return "x.circle"
            case .okay, .cancel, .destructive:
                return ""
            case .done:
                return "checkmark.circle.fill"
            case .createPerson:
                return "person.crop.circle.fill.badge.plus"
            case .addPerson:
                return "person.crop.circle.fill.badge.plus"
            }
        }
    }
    
    var action: () -> Void
    var type: ButtonType
    
    init(_ type: ButtonType, _ action: @escaping () -> Void) {
        self.action = action
        self.type = type
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(type.displayText, systemImage: type.systemImage)
        }
        .if(isDestructive()) { view in
            view.foregroundColor(.red)
        }
    }
    
    func isDestructive() -> Bool {
        switch type {
        case .destructive, .removePerson, .delete, .deleteReceipt, .deleteRestaurant, .deleteFood, .deletePerson, .deleteFood:
            return true
        default:
            return false
        }
    }
}

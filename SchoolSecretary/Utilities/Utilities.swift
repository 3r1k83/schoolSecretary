//
//  Utilities.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 20/12/23.
//

import Foundation
import SwiftUI

struct ViewUtilities {
    static func showAlert(title: String, message: String) -> Alert {
        return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailPredicate.evaluate(with: email)
    }
}

struct Utilities {
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func subjectsToArray(_ subjects: String) -> [String] {
        return subjects
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    let pastelColors: [Color] = [
        Color(red: 151/255, green: 219/255, blue: 214/255), // Teal Pastel
        Color(red: 204/255, green: 223/255, blue: 218/255), // Light Teal
        Color(red: 227/255, green: 240/255, blue: 233/255), // Very Light Teal
        Color(red: 255/255, green: 246/255, blue: 225/255), // Pale Orange
        Color(red: 255/255, green: 221/255, blue: 161/255), // Light Orange
        Color(red: 255/255, green: 200/255, blue: 118/255), // Very Light Orange
        Color(red: 255/255, green: 171/255, blue: 87/255),  // Pastel Orange
        Color(red: 255/255, green: 152/255, blue: 89/255),  // Soft Orange
        Color(red: 255/255, green: 130/255, blue: 101/255), // Peach
        Color(red: 255/255, green: 110/255, blue: 85/255)   // Light Peach
    ]
}

extension UserDefaults {
    var isFirstLaunch: Bool {
        get { return bool(forKey: "isFirstLaunch") }
        set { set(newValue, forKey: "isFirstLaunch") }
    }
}

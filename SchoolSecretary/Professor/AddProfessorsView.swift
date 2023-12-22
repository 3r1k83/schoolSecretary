//
//  AddProfessorsView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI

struct AddProfessorsView: View {
    @Environment(\.modelContext) private var context

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var subjects: String = ""
    
    // Attributi per la gestione dell'alert
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Professor Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Subjects (comma separated)", text: $subjects)
                }
                
                Button(action: addProfessor) {
                    Text("Add Professor")
                }
            }
            .navigationTitle("Add Professor")
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addProfessor() {
        guard !name.isEmpty else {
            showAlert(title: "Invalid Name", message: "Please enter a valid name.")
            return
        }
        
        guard !subjects.isEmpty else {
            showAlert(title: "Invalid Subjects", message: "Each professor must have at least one subject")
            return
        }
        
        guard ViewUtilities.isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        let avatarUrl = "https://api.multiavatar.com/\(name).png"

        let newProfessor = Professor(_id: UUID().uuidString, name: name, email: email, avatarURL: avatarUrl, subjects: Utilities().subjectsToArray(subjects))
        context.insert(newProfessor)
        
        name = ""
        email = ""
        subjects = ""
        
        // Show an alert
        showAlert(title: "Professor Added", message: "The professor has been successfully added.")
    }
    
    private func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}

//
//  AddStudentView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI
import SwiftData

struct AddStudentView: View {
    @Environment(\.modelContext) private var context
    @Query private var students: [Student]

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var notes: String = ""
    @State private var showingAlert: Bool = false
    @State private var alert: Alert?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email).keyboardType(.emailAddress)
                    TextField("Notes", text: $notes)
                }

                Button(action: addStudent) {
                    Text("Add Student")
                }
            }
            .navigationTitle("Add Student")
            .alert(isPresented: $showingAlert) {
                alert ?? Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addStudent() {
        guard !name.isEmpty else {
            showAlert(ViewUtilities.showAlert(title: "Error", message: "Name cannot be empty"))
            return
        }

        guard ViewUtilities.isValidEmail(email) else {
            showAlert(ViewUtilities.showAlert(title: "Invalid Email", message: "Please enter a valid email address"))
            return
        }
        let avatarUrl = "https://api.multiavatar.com/\(name).png"
        
        let newStudent = Student(_id: UUID().uuidString, name: name, email: email, avatarURL: avatarUrl, notes: notes)
        context.insert(newStudent)

        name = ""
        email = ""
        notes = ""

        // Show an alert
        showAlert(ViewUtilities.showAlert(title: "Student Added", message: "The student has been successfully added."))
    }

    private func showAlert(_ alert: Alert) {
        self.alert = alert
        self.showingAlert = true
    }
}

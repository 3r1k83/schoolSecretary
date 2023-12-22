//
//  StudentDetailView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 21/12/23.
//
import SwiftUI
import SwiftData

struct StudentDetailView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var student: Student
    @State private var showAlert = false

    @State private var isEditing = false
    @State private var editedName: String
    @State private var editedEmail: String
    @State private var editedNotes: String
    
    
    init(student: Student) {
        self.student = student
        self._editedName = State(initialValue: student.name)
        self._editedEmail = State(initialValue: student.email ?? "")
        self._editedNotes = State(initialValue: student.notes ?? "")
    }
    
    var body: some View {
        VStack {
            // Mostra l'avatar grande al centro
            AsyncImage(url: URL(string: student.avatarURL ?? "https://api.multiavatar.com/default.png")) { phase in
                switch phase {
                case .empty:
                    // Placeholder image when URL is empty or still loading
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                case .failure:
                    // Placeholder image when loading
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                @unknown default:
                    // Placeholder image unknown situations
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }

            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $editedName)
                        .disabled(!isEditing)
                    TextField("Email", text: $editedEmail)
                        .disabled(!isEditing)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $editedNotes)
                        .disabled(!isEditing)
                }
            }
            
            Button(action: {
                updateStudent()
                isEditing.toggle()
            }) {
                Text(isEditing ? "Save Changes" : "Edit Student")
            }
            .padding()
            .background(isEditing ? Color.green : Color.mint)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom,40)
        }
        .navigationTitle("Student Detail")
        .onAppear {
            // Abilita la modalità di modifica quando la vista appare
            isEditing = false
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Update Successful"),
                message: Text("Student informations has been updated."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func updateStudent() {
        if isEditing == false {
            return
        }
        // Update values
        student.name = editedName
        student.email = editedEmail
        student.notes = editedNotes
        
        context.insert(student)
        showAlert = true
    }
}

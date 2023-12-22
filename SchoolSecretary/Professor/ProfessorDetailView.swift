//
//  StudentDetailView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 21/12/23.
//
import SwiftUI
import SwiftData

struct ProfessorDetailView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var professor: Professor
    @State private var showAlert = false

    @State private var isEditing = false
    @State private var editedName: String
    @State private var editedEmail: String
    @State private var editedSubjects: String
    
    
    init(professor: Professor) {
        self.professor = professor
        self._editedName = State(initialValue: professor.name)
        self._editedEmail = State(initialValue: professor.email ?? "")
        self._editedSubjects = State(initialValue: professor.subjects?.joined(separator: ", ") ?? "")
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: professor.avatarURL ?? "https://api.multiavatar.com/default.png")) { phase in
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
                    TextEditor(text: $editedSubjects)
                        .disabled(!isEditing)
                }
            }
            
            Button(action: {
                updateProfessor()
                isEditing.toggle()
            }) {
                Text(isEditing ? "Save Changes" : "Edit professor")
            }
            .padding()
            .background(isEditing ? Color.green : Color.mint)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom,40)
        }
        .navigationTitle("Professor Detail")
        .onAppear {
            isEditing = false
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Update Successful"),
                message: Text("Professor informations has been updated."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func updateProfessor() {
        if isEditing == false {
            return
        }
        professor.name = editedName
        professor.email = editedEmail
        professor.subjects = Utilities().subjectsToArray(editedSubjects)
        
        context.insert(professor)
        showAlert = true
    }
}

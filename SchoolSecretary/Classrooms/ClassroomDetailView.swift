//
//  ClassroomDetailView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI

struct ClassroomDetailView: View {
    @ObservedObject var classroomManager: ClassroomManager
    @ObservedObject var classroom: Classroom
    @State private var showAlert = false
    @Environment(\.modelContext) private var context
    @State private var selectedProfessor: Professor?
    @State private var selectedStudents: [Student] = []
    @State private var isShowingStudentSearch = false
    @State private var isShowingProfessorList = false
    @State private var isEditing = false
    
    @State private var editedName: String
    @State private var alert: Alert?
    
    init(classroom: Classroom) {
        self.classroom = classroom
        self._classroomManager = ObservedObject(wrappedValue: ClassroomManager())
        self._editedName = State(initialValue: classroom.roomName)
        self._selectedStudents = State(initialValue: classroom.students ?? [])
        self._selectedProfessor = State(initialValue: classroom.professor)
    }
    
    var body: some View {
        VStack {
            Text("Classroom Detail")
                .font(.title)
                .fontWeight(.bold)
            
            Form {
                Section(header: Text("Classroom Information")) {
                    TextField("Room Name", text: $editedName)
                        .disabled(!isEditing)
                    
                    Section {
                        if let professor = selectedProfessor {
                                Text("Professor: \(professor.name)")
                                    .foregroundColor(.primary)
                            } else {
                                Text("No Professor Assigned")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    isShowingProfessorList = true
                                }) {
                                    Text("Edit Professor")
                                        .foregroundColor(.white)
                                }
                                
                                .disabled(!isEditing)
                                .sheet(isPresented: $isShowingProfessorList) {
                                    SelectProfessorView(selectedProfessor: $selectedProfessor)
                                }
                                
                                Spacer()
                            }.foregroundColor(.white)
                            .padding()
                            .background(isEditing ? Color.green.opacity(0.7) : Color.gray.opacity(0.8))
                            .cornerRadius(8)
                    }
                    
                    if let subjects = selectedProfessor?.subjects ?? classroom.professor?.subjects {
                        Text("Subjects: \(subjects.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Students")) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach((selectedStudents.isEmpty ? classroom.students : selectedStudents) ?? [], id: \._id) { student in
                            Text("\(student.name)")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isShowingStudentSearch = true
                        }) {
                            Text("Edit Students")
                                .foregroundColor(.white)
                        }
                        .disabled(!isEditing)
                        .sheet(isPresented: $isShowingStudentSearch) {
                            StudentSearchView(selectedStudents: $selectedStudents)
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(isEditing ? Color.green.opacity(0.7) : Color.gray.opacity(0.8))
                    .cornerRadius(8)
                    .sheet(isPresented: $isShowingStudentSearch) {
                        StudentSearchView(selectedStudents: $selectedStudents)
                    }
                }
            }
            
            Button(action: {
                updateClassroom()
                isEditing.toggle()
            }) {
                Text(isEditing ? "Save Changes" : "Edit Classroom")
                    .foregroundColor(.white)
                    .padding()
                    .background(isEditing ? Color.green : Color.mint)
                    .cornerRadius(8)
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            isEditing = false
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Update Successful"),
                message: Text("Classroom information has been updated."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func updateClassroom() {
        guard isEditing else { return }
        
        classroomManager.updateClassroom(classroom: classroom) { result in
            switch result {
            case .success:
                showAlert = true
            case .failure(let error):
                showAlert(ViewUtilities.showAlert(title: "Error", message: error.localizedDescription))
            }
        }
        
        classroom.students = selectedStudents
        classroom.professor = selectedProfessor
        classroom.roomName = editedName
        context.insert(classroom)
    }
    
    private func showAlert(_ alert: Alert) {
        self.alert = alert
        self.showAlert = true
    }
}

struct ClassroomDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomDetailView(classroom:generateRandomClassroom())
    }
}

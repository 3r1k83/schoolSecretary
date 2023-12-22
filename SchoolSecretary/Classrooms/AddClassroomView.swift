//
//  AddClassroomView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import SwiftUI

struct AddClassroomView: View {
    @ObservedObject var classroomManager: ClassroomManager
    @State private var roomName = ""
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedStudents: [Student] = []
    @State private var selectedProfessor: Professor? = nil
    @State private var isShowingStudentSearch = false
    @State private var isShowingProfessorList = false
    @State private var showingAlert: Bool = false
    @State private var alert: Alert?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Classroom Details")) {
                        TextField("Room Name", text: $roomName)
                    }
                    
                    Section(header: Text("Students")) {
                        VStack {
                            ForEach(selectedStudents, id: \._id) { student in
                                StudentCellView(student: student)
                            }
                        }
                        Button(action: {
                            isShowingStudentSearch = true
                        }) {
                            Text("Add Students")
                        }
                        .tint(Utilities().pastelColors[0])
                        .sheet(isPresented: $isShowingStudentSearch) {
                            // Student search window
                            StudentSearchView(selectedStudents: $selectedStudents)
                        }
                    }
                    
                    Section(header: Text("Professor")) {
                        if let professor = selectedProfessor {
                            ProfessorCellView(professor: professor)
                        }
                        
                        Button(action: {
                            isShowingProfessorList = true
                        }) {
                            Text("Select Professor")
                        }.tint(Utilities().pastelColors[0])
                            .sheet(isPresented: $isShowingProfessorList) {
                                // Professor list window
                                SelectProfessorView(selectedProfessor: $selectedProfessor)
                            }
                    }
                }
                .foregroundColor(Utilities().pastelColors[7])
                .tint(Utilities().pastelColors[0])
                Spacer()
                Button("Add classroom") {
                    addClassroom()
                }
                .padding()
                .background(Utilities().pastelColors[0])
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 30)
            }
            .navigationTitle("Add Classroom")
            .alert(isPresented: $showingAlert) {
                alert ?? Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addClassroom() {
        guard !roomName.isEmpty else {
            showAlert(ViewUtilities.showAlert(title: "Please select a name for your class", message: "Name cannot be empty"))
            return
        }
        guard !selectedStudents.isEmpty else {
            showAlert(ViewUtilities.showAlert(title: "Please select a student", message: "A class must have at least one student"))
            return
        }
        guard selectedProfessor != nil else {
            showAlert(ViewUtilities.showAlert(title: "Please select a professor", message: "A class must have one professor"))
            return
        }
        
        let newClassroom = Classroom(_id: UUID().uuidString, roomName: roomName, students: selectedStudents, professor: selectedProfessor)
        context.insert(newClassroom)
        
        DispatchQueue.main.async {
            classroomManager.addClassroom(classroom: newClassroom) { result in
                switch result {
                case .success(_):
                    showAlert(ViewUtilities.showAlert(title: "Classroom added", message: "The class has been added"))
                    presentationMode.wrappedValue.dismiss()
                    
                case .failure(let error):
                    showAlert(ViewUtilities.showAlert(title: "Error", message: error.localizedDescription))
                }
            }
        }
    }
    
    private func showAlert(_ alert: Alert) {
        self.alert = alert
        self.showingAlert = true
    }
}

// AddClassroomView Preview
struct AddClassroomView_Preview: PreviewProvider {
    static var previews: some View {
        AddClassroomView(classroomManager: ClassroomManager())
    }
}

//
//  StudentsView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI
import SwiftData

struct StudentsListView: View {
    @Query private var students: [Student]
    @State private var searchText: String = ""
    @Environment(\.modelContext) private var context
    @Query var classrooms: [Classroom]
    var uniqueStudents: [Student] { Array(Set(students)) }
    
    // State variables for managing alerts
    @State private var showAlert = false
    @State private var selectedStudent: Student?
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                List {
                    ForEach(filteredStudents, id: \._id) { student in
                        NavigationLink(destination: StudentDetailView(student: student)) {
                            StudentCellView(student: student)
                        }
                    }
                    .onDelete { indexSet in
                        // Show an alert if the student is associated with a classroom
                        guard let student = uniqueStudents[safe: indexSet.first!] else { return }
                        if isStudentInClassroom(student: student) {
                            selectedStudent = student
                            showAlert.toggle()
                        } else {
                            // Delete the student if not associated with a classroom
                            indexSet.map { uniqueStudents[$0] }.forEach { student in
                                // Remove the student from all classrooms
                                classrooms.forEach { classroom in
                                    if let index = classroom.students?.firstIndex(where: { $0 == student }) {
                                        classroom.students?.remove(at: index)
                                    }
                                }
                                context.delete(student)
                            }
                        }
                    }
                    .animation(.default, value: self.filteredStudents)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("You cannot Delete this Student"),
                    message: Text("The student is associated with a classroom."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    var filteredStudents: [Student] {
        searchText.isEmpty ? uniqueStudents : uniqueStudents.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    // Function that checks if a student is associated with a classroom
    private func isStudentInClassroom(student: Student) -> Bool {
        classrooms.contains { classroom in
            classroom.students?.contains(student) ?? false
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@MainActor
let previewContainerStudent: ModelContainer = {
    do {
        let container = try ModelContainer(for: Student.self,
                                           configurations: .init(isStoredInMemoryOnly: true))
        
        for _ in 1...10 {
            container.mainContext.insert(generateRandomStudent())
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

func generateRandomStudent() -> Student {
    let name = Utilities().randomString(length: 8)
    return Student(_id: UUID().uuidString, name: name, email: "robert.johnson@example.com", avatarURL: "https://api.multiavatar.com/robert_johnson.png", notes: "")
}

#Preview {
    StudentsListView()
        .modelContainer(previewContainerStudent)
}

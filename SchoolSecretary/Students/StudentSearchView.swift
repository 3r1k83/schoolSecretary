//
//  StudentSearchView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI
import SwiftData

struct StudentSearchView: View {
    @Binding var selectedStudents: [Student]
    @State private var searchText: String = ""
    @Query private var students: [Student]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)
                ForEach(filteredStudents, id: \.self) { student in
                    
                    Button(action: {
                        toggleSelection(for: student)
                    }) {
                        HStack {
                            StudentCellView(student: student)
                            Spacer()
                            if selectedStudents.contains(student) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green) // Cambia il colore come preferisci
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Students")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .tint(Color.mint)
        }
    }

    private func toggleSelection(for student: Student) {
        if selectedStudents.contains(student) {
            selectedStudents.removeAll { $0 == student }
        } else {
            selectedStudents.append(student)
        }
    }

    private var filteredStudents: [Student] {
        searchText.isEmpty ? students : students.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

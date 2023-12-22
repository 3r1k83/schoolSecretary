//
//  ProfessorListView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//
import SwiftUI
import SwiftData

struct SelectProfessorView: View {
    @Binding var selectedProfessor: Professor?
    @State private var searchText: String = ""
    @Query var professors: [Professor]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)

                ForEach(filteredProfessors, id: \.self) { professor in
                    Button(action: {
                        toggleSelection(for: professor)
                    }) {
                        HStack {
                            ProfessorCellView(professor: professor)
                            Spacer()
                            if selectedProfessor == professor {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green) 
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Professor")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func toggleSelection(for professor: Professor) {
        if selectedProfessor == professor {
                // Se il professore attualmente selezionato è lo stesso, deseleziona
                selectedProfessor = nil
            } else {
                // Altrimenti, seleziona il nuovo professore
                selectedProfessor = professor
            }
    }

    private var filteredProfessors: [Professor] {
        searchText.isEmpty ? professors : professors.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

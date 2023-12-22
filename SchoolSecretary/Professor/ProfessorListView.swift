//
//  ProfessorListView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//
import SwiftUI
import SwiftData

struct ProfessorListView: View {
    @State private var searchText: String = ""
    @Environment(\.modelContext) private var context
    @Query var classrooms: [Classroom]
    @Query var professors: [Professor]
    var uniqueProfessors: [Professor] { Array(Set(professors))}
    @State private var showAlert = false
    @State private var selectedProfessor: Professor?

    var body: some View {
            NavigationView {
                VStack {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    List {
                        ForEach(self.filteredProfessors, id: \._id) { professor in
                            NavigationLink(destination: ProfessorDetailView(professor: professor)) {
                                ProfessorCellView(professor: professor)
                            }
                        }
                        .onDelete { indexSet in
                            // Mostra un alert se il professore è associato a una classe
                            let professor = professors[indexSet.first!]
                            if isProfessorInClassroom(professor: professor) {
                                selectedProfessor = professor
                                showAlert.toggle()
                            } else {
                                indexSet.map { professors[$0] }.forEach { context.delete($0) }
                            }
                        }     
                        .animation(.default, value: self.filteredProfessors)

                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("You cannot Delete this Professor"),
                        message: Text("The professor is associated with a classroom."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    private var filteredProfessors: [Professor] {
        searchText.isEmpty ? uniqueProfessors : uniqueProfessors.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    private func isProfessorInClassroom(professor: Professor) -> Bool {
            for classroom in classrooms {
                if let professorInClassroom = classroom.professor, professorInClassroom == professor {
                    return true
                }
            }
            return false
        }
}

@MainActor
let previewContainerProfessor: ModelContainer = {
    do {
        let container = try ModelContainer(for: Professor.self,
                                           configurations: .init(isStoredInMemoryOnly: true))
 
        for _ in 1...10 {
            container.mainContext.insert(generateRandomProfessor())
        }
 
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

func generateRandomProfessor() -> Professor {
    let subjects = [ "Mathematic","Italian","latin","English" ]
    
    let randomIndex = Int.random(in: 0..<subjects.count)
    let randomSubject = subjects[randomIndex]
    let name = Utilities().randomString(length: 8)
    
    return Professor(_id:UUID().uuidString, name: name, email: "robert.johnson@example.com", avatarURL: "https://api.multiavatar.com/robert_johnson.png", subjects: [randomSubject])
}

#Preview {
    ProfessorListView()
        .modelContainer(previewContainerProfessor)

}



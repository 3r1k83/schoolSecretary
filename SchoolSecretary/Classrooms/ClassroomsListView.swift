//
//  ContentView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

//
//  ContentView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import SwiftUI
import SwiftData

struct ClassroomsListView: View {
    @ObservedObject var classroomManager: ClassroomManager
    @Environment(\.modelContext) private var context
    @Query private var classrooms: [Classroom]
    @Query private var students: [Student]
    @Query private var professors: [Professor]
    @State private var isSyncing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Classrooms")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.bottom, -20)
                List {
                    ForEach(classrooms.indices, id: \.self) { index in
                        let colorIndex = index % Utilities().pastelColors.count
                        let backgroundColor = Utilities().pastelColors[colorIndex]
                        
                        NavigationLink(destination: ClassroomDetailView(classroom: classrooms[index])) {
                            ClassroomCellView(classroom: classrooms[index])
                                .background(backgroundColor)
                                .cornerRadius(8)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { indexSet in
                        // Remove selected classrooms
                        indexSet.map { classrooms[$0] }.forEach {
                            context.delete($0)
                            classroomManager.deleteClassroom(classroom: $0)
                        }
                    }
                    .animation(.default, value: self.classrooms)
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
                
                Button("Add classroom") {
                    classroomManager.showAddClassroomSheet = true
                }
                .padding()
                .background(Color.mint)
                .foregroundColor(.white)
                .cornerRadius(8)
                .sheet(isPresented: $classroomManager.showAddClassroomSheet) {
                    AddClassroomView(classroomManager: classroomManager)
                }
            }
            .padding(.bottom, 50)
            .navigationBarItems(trailing: Button("Sync") {
                syncWithBackend()
            })
            .overlay(
                Group {
                    if isSyncing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .background(Color.white)
                            .opacity(0.8)
                    }
                }
            )
        }
        .onAppear {
            // Call the getClassrooms API to get classrooms from the backend
            classroomManager.syncWithBackend { error in
                if let error = error {
                    print("Error during backend syncing: \(error)")
                } else {
                    syncClassrooms()
                }
            }
        }
    }
    
    private func syncWithBackend() {
        isSyncing = true
        classroomManager.syncWithBackend { error in
            if let error = error {
                print("Error during backend syncing: \(error)")
            } else {
                syncClassrooms()
            }
            isSyncing = false
        }
    }
    
    private func syncClassrooms() {
        // Merge local classrooms with those from the backend
        let mergedClassrooms = mergeClassrooms(local: classrooms, remote: classroomManager.classrooms)
        
        // Update local classrooms with information from the backend
        updateLocalClassrooms(local: &classroomManager.classrooms, remote: mergedClassrooms)
        
        // Add new local classrooms to the backend
        addNewClassroomsToLocal(local: &classroomManager.classrooms, remote: mergedClassrooms)
    }
    
    private func mergeClassrooms(local: [Classroom], remote: [Classroom]) -> [Classroom] {
        var mergedClassrooms = local
        
        // Add classrooms from the backend that are not present locally
        for remoteClassroom in remote where !local.contains(remoteClassroom) {
            mergedClassrooms.append(remoteClassroom)
            context.insert(remoteClassroom)
            
            if let professor = remoteClassroom.professor {
                if !professors.contains(professor) {
                    context.insert(professor)
                }
            }
            
            if let studentsInClass = remoteClassroom.students {
                let newStudents = studentsInClass.filter { !students.contains($0) }
                newStudents.forEach { newStudent in
                    context.insert(newStudent)
                }
            }
        }
        
        return mergedClassrooms
    }
    
    private func updateLocalClassrooms(local: inout [Classroom], remote: [Classroom]) {
        for remoteClassroom in remote {
            if let index = local.firstIndex(where: { $0._id == remoteClassroom._id }) {
                local[index] = remoteClassroom
            }
        }
    }
    
    private func addNewClassroomsToLocal(local: inout [Classroom], remote: [Classroom]) {
        for localClassroom in local where !remote.contains(localClassroom) {
            // Add localClassroom to the backend, for example, via API
            
            classroomManager.addClassroom(classroom: localClassroom, completion: { _ in
                
            })
        }
    }
}


@MainActor
let previewContainerClassroom: ModelContainer = {
    do {
        let container = try ModelContainer(for: Classroom.self,
                                           configurations: .init(isStoredInMemoryOnly: true))
        
        for _ in 1...10 {
            container.mainContext.insert(generateRandomClassroom())
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

func generateRandomClassroom() -> Classroom {
    let randomStudents = (1...10).map { _ in
        generateRandomStudent()
    }
    let randomProfessor = generateRandomProfessor()
    
    let name = Utilities().randomString(length: 8)
    
    return Classroom(_id: UUID().uuidString, roomName: name, students: randomStudents, professor: randomProfessor)
}

#Preview {
    ClassroomsListView(classroomManager: ClassroomManager())
        .modelContainer(previewContainerClassroom)
}

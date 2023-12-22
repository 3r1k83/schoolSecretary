//
//  ClassroomManager.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import Foundation

class ClassroomManager: ObservableObject {
    @Published var classrooms: [Classroom] = []
    @Published var showAddClassroomSheet: Bool = false
    var networkManager = SchoolAPIClient.shared
    
    func getClassrooms() -> [Classroom] {
        return Array(classrooms)
    }
    
    // Function to add a new classroom
    func addClassroom(classroom: Classroom, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !classrooms.contains(classroom) else {
            // Classroom with the same ID already exists
            return
        }

        DispatchQueue.main.async {
            self.classrooms.append(classroom)
            self.networkManager.addClassroom(classroom: classroom) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let addedClassroom):
                    // Show a confirmation message (e.g., an alert or a toast)
                    completion(.success(true))
                    print("Class added successfully: \(addedClassroom)")
                    
                case .failure(let error):
                    // Handle the error (e.g., show an alert)
                    completion(.failure(error))
                    print("Error adding class to the backend: \(error)")
                }
            }
        }
    }
    
    func updateClassroom(classroom: Classroom, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.main.async {
            self.networkManager.updateClassroom(classroom: classroom) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let updatedClassroom):
                    // Show a confirmation message (e.g., an alert or a toast)
                    completion(.success(true))
                    print("Class updated successfully: \(updatedClassroom)")
                    
                case .failure(let error):
                    completion(.failure(error))
                    print("Error updating class to the backend: \(error)")
                }
            }
        }
    }
    
    func deleteClassroom(classroom: Classroom) {
        guard let index = classrooms.firstIndex(where: { $0._id == classroom._id }) else {
            // Classroom not found
            return
        }
        
        classrooms.remove(at: index)
        self.networkManager.deleteClassroom(id: classroom._id) { result in
            switch result {
            case .success:
                print("Delete class from server success")
                
            case .failure(let error):
                print("Delete class from server failed with error: \(error)")
            }
        }
    }
    
    func syncWithBackend(completion: @escaping (Error?) -> Void) {
        fetchClassroomsFromBackend { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let classroomsFromBackend):
                DispatchQueue.main.async {
                    // Update local
                    self.classrooms = classroomsFromBackend
                    
                    // Remove duplicates
                    let uniqueClassrooms = self.classrooms
                        .reduce(into: ([Classroom](), Set<String>())) { result, classroom in
                            if !result.1.contains(classroom._id) {
                                result.0.append(classroom)
                                result.1.insert(classroom._id)
                            }
                        }.0
                    
                    self.classrooms = uniqueClassrooms
                    completion(nil)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    private func fetchClassroomsFromBackend(completion: @escaping (Result<[Classroom], Error>) -> Void) {
        self.networkManager.getClassrooms { result in
            completion(result)
        }
    }
}

//
//  SchoolSecretaryAPI.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import Foundation

// Network layer protocol
protocol SchoolSecretaryAPI {
    func ping(completion: @escaping (Result<Bool, Error>) -> Void)
    func getClassrooms(completion: @escaping (Result<[Classroom], Error>) -> Void)
    func addClassroom(classroom: Classroom, completion: @escaping (Result<Classroom, Error>) -> Void)
    func updateClassroom(classroom: Classroom, completion: @escaping (Result<Classroom, Error>) -> Void)
    func getClassroom(id: String, completion: @escaping (Result<Classroom, Error>) -> Void)
    func deleteClassroom(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

// Network layer implementation
class SchoolAPIClient: SchoolSecretaryAPI {
    
    static let shared = SchoolAPIClient()

    private var baseURL: URL = ApiConstants.baseUrl
    private var accessToken: String = ApiConstants.apiKey
    var urlSession = URLSession.shared

    func ping(completion: @escaping (Result<Bool, Error>) -> Void) {
        let pingURL = baseURL.appendingPathComponent("/ping")
        var request = URLRequest(url: pingURL)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([String: Bool].self, from: data)
                if let success = result["success"] {
                    completion(.success(success))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getClassrooms(completion: @escaping (Result<[Classroom], Error>) -> Void) {
        let classroomsURL = baseURL.appendingPathComponent("/classrooms")
        var request = URLRequest(url: classroomsURL)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
//                print(String(data: data, encoding: .utf8))
                let response = try JSONDecoder().decode(ClassroomsResponse.self, from: data)
                completion(.success(response.classrooms))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
        
    
    func addClassroom(classroom: Classroom, completion: @escaping (Result<Classroom, Error>) -> Void) {
        let addCompleteClassroomURL = baseURL.appendingPathComponent("/classroom/\(classroom._id)")
        var request = URLRequest(url: addCompleteClassroomURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(classroom)
            request.httpBody = requestBody
        } catch {
            completion(.failure(error))
            return
        }
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let classroom = try JSONDecoder().decode(Classroom.self, from: data)
                completion(.success(classroom))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func updateClassroom(classroom: Classroom, completion: @escaping (Result<Classroom, Error>) -> Void) {
        let updateClassroomURL = baseURL.appendingPathComponent("/classroom/\(classroom._id)")
        var request = URLRequest(url: updateClassroomURL)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(classroom)
            request.httpBody = requestBody
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let classroom = try JSONDecoder().decode(Classroom.self, from: data)
                completion(.success(classroom))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getClassroom(id: String, completion: @escaping (Result<Classroom, Error>) -> Void) {
        let classroomURL = baseURL.appendingPathComponent("/classroom/\(id)")
        var request = URLRequest(url: classroomURL)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let classroom = try JSONDecoder().decode(Classroom.self, from: data)
                completion(.success(classroom))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func deleteClassroom(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let deleteClassroomURL = baseURL.appendingPathComponent("/classroom/\(id)")
        var request = URLRequest(url: deleteClassroomURL)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                completion(.success(true))
            case 404:
                // Classroom not found
                completion(.success(false))
            default:
                completion(.failure(NetworkError.invalidResponse))
            }
        }.resume()
    }
    
}

// Enum per gestire gli errori di rete
enum NetworkError: Error {
    case noData
    case invalidResponse
}

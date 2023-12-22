//
//  Classroom.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import Foundation
import SwiftData

@Model
class Classroom: Codable, Hashable, ObservableObject {
    var _id: String
    var roomName: String
    var students: [Student]?
    var professor: Professor?
    
    enum CodingKeys: CodingKey {
        case _id
        case roomName
        case students
        case professor
        }
    
    init (_id: String = "1", roomName: String = "", students: [Student]?, professor: Professor?){
        self._id = _id
        self.roomName = roomName
        self.students = students
        self.professor = professor
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(String.self, forKey: ._id)
        self.roomName = try container.decode(String.self, forKey: .roomName)
        self.students = try container.decodeIfPresent([Student].self, forKey: .students) ?? []
        self.professor = try container.decodeIfPresent(Professor.self, forKey: .professor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(roomName, forKey: .roomName)
        try container.encode(students, forKey: .students)
        try container.encode(professor, forKey: .professor)
    }
    
}

extension Classroom: Equatable {
    static func == (lhs: Classroom, rhs: Classroom) -> Bool {
        return lhs._id == rhs._id

    }
}

struct ClassroomsResponse: Codable {
    let classrooms: [Classroom]
}


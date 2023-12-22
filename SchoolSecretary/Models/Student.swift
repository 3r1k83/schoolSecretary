//
//  Classroom.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import Foundation
import SwiftData

@Model
class Student: Codable, Hashable, ObservableObject {
    var _id: String
    var name: String
    var email: String?
    var avatarURL: String?
    var notes: String?
    
    enum CodingKeys: CodingKey {
        case _id
        case name
        case email
        case avatarURL
        case notes
        }
    init(_id: String = "", name: String = "", email: String? = "", avatarURL: String? = "", notes: String? = ""){
        self._id = _id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.notes = notes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(String.self, forKey: ._id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(notes, forKey: .notes)
    }
}

extension Student: Equatable {
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs._id == rhs._id

    }
}



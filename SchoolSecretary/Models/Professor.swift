//
//  Classroom.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import Foundation
import SwiftData

@Model
class Professor: Codable, Hashable, ObservableObject {
    var _id: String
    var name: String
    var email: String?
    var avatarURL: String?
    var subjects: [String]?
    
    enum CodingKeys: CodingKey {
        case _id
        case name
        case email
        case avatarURL
        case subjects
    }
    
    init(_id: String = "", name: String = "", email: String? = "", avatarURL: String? = "", subjects: [String]? = []){
        self._id = _id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.subjects = subjects
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(String.self, forKey: ._id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        self.subjects = try container.decodeIfPresent([String].self, forKey: .subjects)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(subjects, forKey: .subjects)
    }
}

extension Professor: Equatable {
    static func == (lhs: Professor, rhs: Professor) -> Bool {
        return lhs._id == rhs._id

    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
        hasher.combine(name)
        hasher.combine(email)
        hasher.combine(avatarURL)
        hasher.combine(subjects)
    }
}

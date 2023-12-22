//
//  ClassroomCellView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 22/12/23.
//

import SwiftUI

struct ClassroomCellView: View {
    var classroom: Classroom
    
    var body: some View {
        HStack {
            Image("Classroom")  
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .padding(3)

            VStack(alignment: .leading, spacing: 8) {
                Text(classroom.roomName)
                    .font(.headline)
                
                if let professor = classroom.professor {
                    Text("Professor: \(professor.name)")
                        .font(.subheadline)
                }
                
                if let subjects = classroom.professor?.subjects {
                    Text("Subjects: \(subjects.map { $0 }.joined(separator: ", "))")
                        .font(.subheadline)
                }
            }
            .padding(12)
            
            Spacer()
        }
    }
}

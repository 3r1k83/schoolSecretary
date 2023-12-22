//
//  ProfessorCellView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 20/12/23.
//

import Foundation
import SwiftUI

struct ProfessorCellView: View {
    var professor: Professor
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: professor.avatarURL ?? "https://api.multiavatar.com/default.png")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                case .failure(_):
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 10)
                @unknown default:
                    EmptyView()
                }
            }
            
            // Nome e email dello studente
            VStack(alignment: .leading) {
                Text(professor.name)
                    .font(.headline)
                Text(professor.email?.lowercased() ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(professor.subjects?.joined(separator: ", ") ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            
            Spacer()
        }
        .padding(10)
    }
}

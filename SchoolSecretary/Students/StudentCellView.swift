//
//  StudentCellView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 20/12/23.
//

import Foundation
import SwiftUI

struct StudentCellView: View {
    var student: Student
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: student.avatarURL ?? "https://api.multiavatar.com/default.png")) { phase in
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
            
            VStack(alignment: .leading) {
                Text(student.name)
                    .font(.headline)
                Text(student.email?.lowercased() ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(10)
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color(UIColor.systemBackground).opacity(0.8))
//        )
    }
}

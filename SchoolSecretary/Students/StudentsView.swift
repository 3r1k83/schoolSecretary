//
//  StudentsView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 22/12/23.
//

import SwiftUI

struct StudentsView: View {
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Students")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.bottom,10)
                StudentsListView()
            }
                .navigationBarItems(trailing: NavigationLink("Add student", destination: AddStudentView()))
        }
        
    }
}
struct StudentsView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsView()
    }
}

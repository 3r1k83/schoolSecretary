//
//  ProfessorsView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI

struct ProfessorsView: View {
    
    var body: some View {
        NavigationView {
            ProfessorListView()
                .navigationBarTitle("Professors")
                .navigationBarItems(trailing: NavigationLink("Add professor", destination: AddProfessorsView()))
        }
        
    }
}


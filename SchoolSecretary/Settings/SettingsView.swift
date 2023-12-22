//
//  SettingsView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedTab: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top,30)
                    
                    Spacer()
                    Image("School")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                    Text("By logging out, the database will be cleared. Upon the next app launch, classes, students, and professors will be loaded through API requests.")
                        .font(.callout)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(20)
                        .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                        ).padding(30)
                    NavigationLink(
                        destination: IntroView(),
                        label: {
                            EmptyView()
                        }
                    )
                    Spacer()
                    
                   
                    Button(action: {
                        // Esegui il logout e resetta i dati del database
                        logoutAndResetData()
                    }) {
                        Text("Logout")
                            .foregroundColor(.white)
                        
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.bottom,40)
                    Spacer()
                }
            }
            .navigationBarHidden(true)        }
        
    }
    
    private func logoutAndResetData(){
        UserDefaults.standard.set(false, forKey: "isAppAlreadyLaunched")
        do {
            try context.delete(model: Student.self)
            try context.delete(model: Professor.self)
            try context.delete(model: Classroom.self)
        } catch {
            print("Failed to clear all Country and City data.")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

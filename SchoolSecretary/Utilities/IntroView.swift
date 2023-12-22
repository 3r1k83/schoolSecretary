//
//  IntroView.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 19/12/23.
//

import SwiftUI

struct IntroView: View {
    @State private var isAppAlreadyLaunched: Bool = UserDefaults.standard.bool(forKey: "isAppAlreadyLaunched")

    var body: some View {
            VStack {
                Text("Welcome to SchoolSecretary!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Text("This is your app to manage classrooms, students and professors")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunched")
                }) {
                    Text("Start")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
        }
    }
}

//
//  SchoolSecretaryApp.swift
//  SchoolSecretary
//
//  Created by Erik Peruzzi on 18/12/23.
//

import SwiftUI
import SwiftData


@main
struct SchoolSecretaryApp: App {
    @State private var selectedProfessor: Professor? = nil
    @State private var showAlert: Bool = false
    @State private var isIntroPresented: Bool = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Classroom.self,
            Student.self,
            Professor.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        setupAppearance()
        checkIfIntroNeeded()
    }
    
    private func checkIfIntroNeeded() {
        isIntroPresented = UserDefaults.standard.bool(forKey: "isAppAlreadyLaunched")
    }
    
    private func setupAppearance() {
        // Change app tint color
        let tintColor = UIColor(red: 0.5, green: 0.8, blue: 0.7, alpha: 1.0)
        UINavigationBar.appearance().tintColor = tintColor
        UITabBar.appearance().tintColor = tintColor
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isFirstLaunch {
                    IntroView()
                } else {
                    MainTabbedView()
                        .modelContainer(sharedModelContainer)
                        .onAppear {
                            SchoolAPIClient.shared.ping { result in
                                switch result {
                                case .success:
                                    print("Ping success")
                                case .failure(let error):
                                    print("Ping failed with error: \(error)")
                                    showAlert = true
                                }
                            }
                            isFirstLaunch = false
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Connection Error"),
                                message: Text("There was an issue connecting to the server. Please check your internet connection and try again."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                }
            }
        }
    }
}

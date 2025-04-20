//
//  PlantCareApp.swift
//  GreenThumbV2
//
//  Created by Pedro Inurreta on 17/04/25.
//


import SwiftUI

@main
struct PlantCareApp: App {
    @StateObject private var plantRepository = PlantRepository()
    
    var body: some Scene {
        WindowGroup {
            if plantRepository.activeUser != nil {
                MainTabView()
                    .environmentObject(plantRepository)
            } else {
                AuthView()
                    .environmentObject(plantRepository)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var plantRepository: PlantRepository
    
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label("Catálogo", systemImage: "leaf.fill")
                }
            
            MyPlantsView()
                .tabItem {
                    Label("Mis Plantas", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
        .accentColor(.green)
    }
}

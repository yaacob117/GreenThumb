//
//  PlantDetailView.swift
//  GreenThumbV2
//
//  Created by Pedro Inurreta on 17/04/25.
//


import SwiftUI

struct PlantDetailView: View {
    @EnvironmentObject var plantRepository: PlantRepository
    let plant: Plant
    
    var isInMyPlants: Bool {
        guard let user = plantRepository.activeUser else { return false }
        return user.myPlants.contains(where: { $0.id == plant.id })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.green.opacity(0.1))
                    
                    Button(action: {
                        if isInMyPlants {
                            plantRepository.removeFromMyPlants(plantId: plant.id)
                        } else {
                            plantRepository.addToMyPlants(plant: plant)
                        }
                    }) {
                        Image(systemName: isInMyPlants ? "heart.fill" : "heart")
                            .font(.title)
                            .padding(10)
                            .background(Color.white)
                            .foregroundColor(isInMyPlants ? .red : .gray)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(plant.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(plant.scientificName)
                        .font(.title3)
                        .italic()
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Dificultad:")
                            .fontWeight(.medium)
                        
                        Text(plant.difficulty.rawValue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                plant.difficulty == .easy ? Color.green.opacity(0.2) :
                                    plant.difficulty == .medium ? Color.yellow.opacity(0.2) :
                                    Color.red.opacity(0.2)
                            )
                            .foregroundColor(
                                plant.difficulty == .easy ? Color.green :
                                    plant.difficulty == .medium ? Color.orange :
                                    Color.red
                            )
                            .cornerRadius(10)
                    }
                    
                    Text("Descripción")
                        .font(.headline)
                        .padding(.top, 5)
                    
                    Text(plant.description)
                        .foregroundColor(.secondary)
                    
                    Text("Cuidados")
                        .font(.headline)
                        .padding(.top, 5)
                    
                    CareInstructionRow(icon: "drop.fill", color: .blue, title: "Riego:", details: plant.careInstructions.waterFrequency)
                    CareInstructionRow(icon: "sun.max.fill", color: .orange, title: "Luz:", details: plant.careInstructions.sunlight)
                    CareInstructionRow(icon: "thermometer", color: .red, title: "Temperatura:", details: plant.careInstructions.temperature)
                    CareInstructionRow(icon: "humidity.fill", color: .blue, title: "Humedad:", details: plant.careInstructions.humidity)
                    CareInstructionRow(icon: "mountain.2.fill", color: .brown, title: "Suelo:", details: plant.careInstructions.soil)
                    CareInstructionRow(icon: "leaf.fill", color: .green, title: "Fertilización:", details: plant.careInstructions.fertilization)
                    CareInstructionRow(icon: "scissors", color: .gray, title: "Poda:", details: plant.careInstructions.pruning)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct CareInstructionRow: View {
    let icon: String
    let color: Color
    let title: String
    let details: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.medium)
                
                Text(details)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct MyPlantsView: View {
    @EnvironmentObject var plantRepository: PlantRepository
    @State private var searchText: String = ""
    
    var myPlants: [Plant] {
        guard let user = plantRepository.activeUser else { return [] }
        
        if searchText.isEmpty {
            return user.myPlants
        } else {
            return user.myPlants.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.scientificName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if myPlants.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("No tienes plantas guardadas")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Añade plantas a tu colección desde el catálogo")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: CatalogView()) {
                            Text("Explorar catálogo")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    TextField("Buscar en mis plantas...", text: $searchText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding([.horizontal, .top])
                    
                    List {
                        ForEach(myPlants) { plant in
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                PlantRowView(plant: plant)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    plantRepository.removeFromMyPlants(plantId: plant.id)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Mis Plantas")
        }
    }
}



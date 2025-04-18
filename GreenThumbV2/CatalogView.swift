//
//  CatalogView.swift
//  GreenThumbV2
//
//  Created by Pedro Inurreta on 17/04/25.
//


import SwiftUI

// Vista del catálogo de plantas
struct CatalogView: View {
    @EnvironmentObject var plantRepository: PlantRepository
    @State private var searchText: String = ""
    @State private var selectedDifficulty: Plant.Difficulty? = nil
    
    var filteredPlants: [Plant] {
        var result = plantRepository.plants
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.scientificName.lowercased().contains(searchText.lowercased())
            }
        }
        
        if let difficulty = selectedDifficulty {
            result = result.filter { $0.difficulty == difficulty }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Buscador
                TextField("Buscar plantas...", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Filtros de dificultad
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            selectedDifficulty = nil
                        }) {
                            Text("Todas")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedDifficulty == nil ? Color.green : Color.gray.opacity(0.1))
                                .foregroundColor(selectedDifficulty == nil ? .white : .primary)
                                .cornerRadius(20)
                        }
                        
                        ForEach(Plant.Difficulty.allCases, id: \.self) { difficulty in
                            Button(action: {
                                selectedDifficulty = difficulty
                            }) {
                                Text(difficulty.rawValue)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedDifficulty == difficulty ? Color.green : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedDifficulty == difficulty ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Lista de plantas
                if filteredPlants.isEmpty {
                    VStack {
                        Spacer()
                        Text("No se encontraron plantas que coincidan con tu búsqueda")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                } else {
                    List(filteredPlants) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            PlantRowView(plant: plant)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Catálogo de Plantas")
        }
    }
}

// Vista de fila para cada planta
struct PlantRowView: View {
    let plant: Plant
    
    var body: some View {
        HStack(spacing: 15) {
            // Imagen de la planta (placeholder)
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
                .padding(5)
                .background(Color.green.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(plant.name)
                    .font(.headline)
                
                Text(plant.scientificName)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text(plant.careInstructions.waterFrequency)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Etiqueta de dificultad
                Text(plant.difficulty.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
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
        }
        .padding(.vertical, 8)
    }
}
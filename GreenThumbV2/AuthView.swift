//
//  AuthView.swift
//  GreenThumbV2
//
//  Created by Pedro Inurreta on 17/04/25.
//


import SwiftUI

struct AuthView: View {
    @EnvironmentObject var plantRepository: PlantRepository
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLogin: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                Text("Green Thumb")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    TextField("Nombre de usuario", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        if isLogin {
                            if plantRepository.login(username: username, password: password) {
                            } else {
                                alertMessage = "Usuario o contraseña incorrectos"
                                showAlert = true
                            }
                        } else {
                            if username.isEmpty || password.isEmpty {
                                alertMessage = "Por favor complete todos los campos"
                                showAlert = true
                            } else if plantRepository.register(username: username, password: password) {
                            } else {
                                alertMessage = "Ya existe un usuario registrado"
                                showAlert = true
                            }
                        }
                    }) {
                        Text(isLogin ? "Iniciar Sesión" : "Registrarse")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        isLogin.toggle()
                    }) {
                        Text(isLogin ? "¿No tienes cuenta? Regístrate" : "¿Ya tienes cuenta? Inicia sesión")
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Atención"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarHidden(true)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var plantRepository: PlantRepository
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    
                    Text(plantRepository.activeUser?.username ?? "Usuario")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 30)
                
                VStack(spacing: 5) {
                    Text("Tu Colección")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(plantRepository.activeUser?.myPlants.count ?? 0)")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("plantas guardadas")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("Cerrar Sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Cerrar Sesión"),
                    message: Text("¿Estás seguro de que deseas cerrar sesión?"),
                    primaryButton: .destructive(Text("Cerrar Sesión")) {
                        plantRepository.logout()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

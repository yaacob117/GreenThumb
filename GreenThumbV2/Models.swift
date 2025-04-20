//
//  Plant.swift
//  GreenThumbV2
//
//  Created by Pedro Inurreta on 17/04/25.
//

import Foundation

struct Plant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let scientificName: String
    let imageURL: String
    let description: String
    let careInstructions: CareInstructions
    let difficulty: Difficulty
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Fácil"
        case medium = "Media"
        case hard = "Difícil"
    }
}

struct CareInstructions: Codable {
    let waterFrequency: String
    let sunlight: String
    let temperature: String
    let humidity: String
    let soil: String
    let fertilization: String
    let pruning: String
}

struct User: Codable, Identifiable {
    let id = UUID()
    let username: String
    let password: String
    var myPlants: [Plant]
}

struct UserDatabase: Codable {
    var users: [User]
}

class PlantRepository: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var activeUser: User?
    
    private var userDatabase: UserDatabase
    private let userDatabaseKey = "userDatabaseKey"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: userDatabaseKey),
           let savedUserDatabase = try? JSONDecoder().decode(UserDatabase.self, from: data) {
            self.userDatabase = savedUserDatabase
        } else {
            self.userDatabase = UserDatabase(users: [])
        }
        
        loadPlantCatalog()
    }
    
    func loadPlantCatalog() {
       
        plants = [
            Plant(
                name: "Monstera Deliciosa",
                scientificName: "Monstera deliciosa",
                imageURL: "monstera",
                description: "Conocida por sus hojas grandes y perforadas, la Monstera es una planta originaria de las selvas tropicales de América Central.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 1-2 semanas, permitiendo que la tierra se seque entre riegos",
                    sunlight: "Luz indirecta brillante",
                    temperature: "18-30°C",
                    humidity: "Media a alta",
                    soil: "Mezcla bien drenada, rica en materia orgánica",
                    fertilization: "Mensual durante primavera y verano",
                    pruning: "Ocasional para eliminar hojas amarillas o dañadas"
                ),
                difficulty: .medium
            ),
            Plant(
                name: "Pothos",
                scientificName: "Epipremnum aureum",
                imageURL: "pothos",
                description: "Planta trepadora de hojas brillantes, perfecta para principiantes debido a su resistencia y fácil mantenimiento.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 7-10 días, cuando la tierra esté seca al tacto",
                    sunlight: "Luz indirecta a sombra parcial",
                    temperature: "15-24°C",
                    humidity: "Tolera humedad baja",
                    soil: "Cualquier tierra universal para macetas",
                    fertilization: "Cada 2-3 meses con fertilizante diluido",
                    pruning: "Ocasional para controlar crecimiento"
                ),
                difficulty: .easy
            ),
            Plant(
                name: "Calathea Medallion",
                scientificName: "Calathea medallion",
                imageURL: "calathea",
                description: "Famosa por sus hermosas hojas decorativas con patrones ornamentales en la parte superior y púrpura en la parte inferior.",
                careInstructions: CareInstructions(
                    waterFrequency: "Mantener tierra húmeda pero no empapada",
                    sunlight: "Luz indirecta o filtrada",
                    temperature: "18-24°C",
                    humidity: "Alta, beneficia de humidificador",
                    soil: "Mezcla rica en nutrientes con buen drenaje",
                    fertilization: "Mensual en temporada de crecimiento",
                    pruning: "Recortar hojas dañadas cuando sea necesario"
                ),
                difficulty: .hard
            ),
            Plant(
                name: "Suculenta Echeveria",
                scientificName: "Echeveria elegans",
                imageURL: "echeveria",
                description: "Planta de roseta compacta con hojas carnosas en tonos azul-verdosos, originaria de zonas áridas de México.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 2-3 semanas, menos en invierno",
                    sunlight: "Luz directa a indirecta brillante",
                    temperature: "18-27°C",
                    humidity: "Baja",
                    soil: "Mezcla especial para cactus y suculentas",
                    fertilization: "Esporádica, cada 3 meses en primavera y verano",
                    pruning: "Raramente necesario"
                ),
                difficulty: .easy
            ),
            Plant(
                name: "Helecho Boston",
                scientificName: "Nephrolepis exaltata",
                imageURL: "fern",
                description: "Helecho de interior popular con frondas arqueadas y plumosas que puede crecer hasta formar una planta grande y exuberante.",
                careInstructions: CareInstructions(
                    waterFrequency: "Frecuente, mantener tierra constantemente húmeda",
                    sunlight: "Luz indirecta o filtrada",
                    temperature: "16-24°C",
                    humidity: "Alta",
                    soil: "Rica en materia orgánica con buen drenaje",
                    fertilization: "Mensual durante primavera y verano",
                    pruning: "Recortar frondas secas o dañadas"
                ),
                difficulty: .medium
            ),
            Plant(
                name: "Orquídea Phalaenopsis",
                scientificName: "Phalaenopsis sp.",
                imageURL: "orchid",
                description: "Conocida como orquídea mariposa, produce flores duraderas en tallos arqueados y es una de las orquídeas más fáciles de cultivar en casa.",
                careInstructions: CareInstructions(
                    waterFrequency: "Una vez por semana, dejando secar entre riegos",
                    sunlight: "Luz indirecta brillante, sin sol directo",
                    temperature: "18-29°C durante el día, caída de 5-10°C por la noche",
                    humidity: "50-70%",
                    soil: "Mezcla especial para orquídeas o corteza",
                    fertilization: "Quincenal con fertilizante diluido",
                    pruning: "Cortar tallos florales después de que las flores se marchiten"
                ),
                difficulty: .medium
            ),
            Plant(
                name: "Sansevieria",
                scientificName: "Dracaena trifasciata",
                imageURL: "sansevieria",
                description: "También conocida como lengua de suegra o espada de San Jorge, es extremadamente resistente con hojas erectas y puntiagudas.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 2-6 semanas, permitiendo que se seque completamente",
                    sunlight: "Adaptable, desde luz baja hasta directa",
                    temperature: "15-30°C",
                    humidity: "Tolera cualquier nivel",
                    soil: "Bien drenada, mezcla para cactus funciona bien",
                    fertilization: "Esporádica, 2-3 veces al año",
                    pruning: "Raramente necesario"
                ),
                difficulty: .easy
            ),
            Plant(
                name: "Ficus Lyrata",
                scientificName: "Ficus lyrata",
                imageURL: "fiddle_leaf",
                description: "Conocido como ficus lira por sus grandes hojas en forma de violín, es una planta de interior popular pero algo exigente.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 7-10 días, permitiendo que la superficie se seque",
                    sunlight: "Luz indirecta brillante",
                    temperature: "18-24°C",
                    humidity: "Media a alta",
                    soil: "Rica en nutrientes con buen drenaje",
                    fertilization: "Mensual en temporada de crecimiento",
                    pruning: "Ocasional para mantener forma deseada"
                ),
                difficulty: .hard
            ),
            Plant(
                name: "Cactus Estrella",
                scientificName: "Astrophytum ornatum",
                imageURL: "cactus",
                description: "Cactus de crecimiento lento con forma globular que desarrolla costillas prominentes y espinas llamativas.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 2-4 semanas en verano, casi nada en invierno",
                    sunlight: "Luz directa a indirecta brillante",
                    temperature: "10-32°C",
                    humidity: "Baja",
                    soil: "Muy bien drenada, específica para cactus",
                    fertilization: "2-3 veces al año en temporada de crecimiento",
                    pruning: "No necesario"
                ),
                difficulty: .easy
            ),
            Plant(
                name: "Planta ZZ",
                scientificName: "Zamioculcas zamiifolia",
                imageURL: "zz_plant",
                description: "Planta extremadamente resistente con hojas brillantes y tallos gruesos que almacenan agua, ideal para principiantes.",
                careInstructions: CareInstructions(
                    waterFrequency: "Cada 2-3 semanas, menos en invierno",
                    sunlight: "Tolera luz baja a indirecta brillante",
                    temperature: "16-26°C",
                    humidity: "Tolera niveles bajos",
                    soil: "Bien drenada",
                    fertilization: "Cada 3 meses en temporada de crecimiento",
                    pruning: "Raramente necesario"
                ),
                difficulty: .easy
            )
        ]
    }
    
    private func saveUserDatabase() {
        if let encodedData = try? JSONEncoder().encode(userDatabase) {
            UserDefaults.standard.set(encodedData, forKey: userDatabaseKey)
        }
    }
    
    private func syncActiveUser() {
        if let activeUser = activeUser {
            if let index = userDatabase.users.firstIndex(where: { $0.username == activeUser.username }) {
                userDatabase.users[index] = activeUser
                saveUserDatabase()
            }
        }
    }
    
    func login(username: String, password: String) -> Bool {
        if let user = userDatabase.users.first(where: {
            $0.username == username && $0.password == password
        }) {
            self.activeUser = user
            return true
        }
        return false
    }
    
    func register(username: String, password: String) -> Bool {
        if userDatabase.users.contains(where: { $0.username == username }) {
            return false
        }
        
        let newUser = User(username: username, password: password, myPlants: [])
        userDatabase.users.append(newUser)
        
        saveUserDatabase()
        
        self.activeUser = newUser
        
        return true
    }
    
    func logout() {
        syncActiveUser()
        
        self.activeUser = nil
    }
    
    func addToMyPlants(plant: Plant) {
        if var user = activeUser {
            if !user.myPlants.contains(where: { $0.id == plant.id }) {
                user.myPlants.append(plant)
                activeUser = user
                syncActiveUser()
            }
        }
    }
    
    func removeFromMyPlants(plantId: UUID) {
        if var user = activeUser {
            user.myPlants.removeAll(where: { $0.id == plantId })
            activeUser = user
            syncActiveUser()
        }
    }
    
    func deleteAccount() -> Bool {
        if let activeUser = activeUser {
            userDatabase.users.removeAll(where: { $0.username == activeUser.username })
            saveUserDatabase()
            self.activeUser = nil
            return true
        }
        return false
    }
    
    func getAllUsernames() -> [String] {
        return userDatabase.users.map { $0.username }
    }
}

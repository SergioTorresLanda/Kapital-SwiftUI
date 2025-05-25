//
//  AmiiboRepository.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 24/05/25.
//

import Foundation
import SwiftUI
import SwiftData

protocol AmiiboRepositoryProtocol {
    func fetchAndPersistAmiibos() async throws
    func addFavorite(_ amiibo: AmiiboObj)
    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj])
    func deleteFavorite(id: String, in favs: [AmiiboObj])
    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj])
    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj]
}

class AmiiboRepository: AmiiboRepositoryProtocol {
    private var modelContext: ModelContext
    private let uRL = URL(string: "https://www.amiiboapi.com/api/amiibo/")

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAndPersistAmiibos() async throws {

        guard let apiURL = uRL else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: apiURL)
        // ... (Error handling and decoding) ...
        let resp = try JSONDecoder().decode(AmiiboResp.self, from: data)

        // Persist received Amiibo data
        resp.amiibo.forEach { apiAmiibo in
            // Revisar si ya se guardo para no guardar duplicados..
            do {
                let existing = try modelContext.fetch(FetchDescriptor<AmiiboObj>(predicate: #Predicate { $0.tail == apiAmiibo.tail }))
                if let existingAmiibo = existing.first {
                    //de momento no hace falta hacer nada si encuentra un duplicado
                } else {
                    let newAmiiboObj = AmiiboObj(amiiboObj: apiAmiibo)
                    modelContext.insert(newAmiiboObj)
                }
            } catch {
                print("Error checking for existing Amiibo: \(error)")
            }
        }
    }

    func addFavorite(_ amiibo: AmiiboObj) {
        amiibo.isFavorite = true
        // No need to insert if it's already in the context. Just modify and save.
        try? modelContext.save() // If you want to force save immediately
    }

    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) {
        for index in offsets {
            modelContext.delete(amiibos[index])
        }
        try? modelContext.save()
    }

    func deleteFavorite(id: String, in favs: [AmiiboObj]) {
        if let amiiboToDelete = favs.first(where: { $0.id == id }) {
            modelContext.delete(amiiboToDelete)
        }
        try? modelContext.save()
    }

    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) {
        for index in offsets {
            modelContext.delete(favs[index])
        }
        try? modelContext.save()
    }

    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj] {
         let descriptor = FetchDescriptor<AmiiboObj>(predicate: #Predicate { $0.isFavorite == isFavorite }, sortBy: [SortDescriptor(\.name)])
         return try modelContext.fetch(descriptor)
     }
}

class MockDataService: AmiiboRepositoryProtocol {
    private var modelContext: ModelContext
    let mockAmiiboObj = AmiiboObj(amiiboObj: .dummy)

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchAndPersistAmiibos() async throws {
        modelContext.insert(mockAmiiboObj)
    }
    
    func addFavorite(_ amiibo: AmiiboObj) {
    }
    
    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) {
    }
    
    func deleteFavorite(id: String, in favs: [AmiiboObj]) {
    }
    
    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) {
    }
    
    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj] {
        return [mockAmiiboObj]
    }
}

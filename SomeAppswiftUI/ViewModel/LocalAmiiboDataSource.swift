//
//  LocalAmiiboDataSource.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 24/05/25.
//  Handles SwiftData Storage

import Foundation
import SwiftData

protocol LocalAmiiboDataSourceProtocol {
    func insertOrUpdate(amiibos: [Amiibo]) throws
    func addFavorite(_ amiibo: AmiiboObj) throws
    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) throws
    func deleteFavorite(id: String, in favs: [AmiiboObj]) throws
    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) throws
    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj]
}

class LocalAmiiboDataSource: LocalAmiiboDataSourceProtocol {
    
    private var modelContext: ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insertOrUpdate(amiibos: [Amiibo]) throws {
        try amiibos.forEach { apiAmiibo in
            let existing = try modelContext.fetch(FetchDescriptor<AmiiboObj>(predicate: #Predicate { $0.name == apiAmiibo.name }))
            if let existingAmiibo = existing.first {
                // Update logic here if needed
            } else {
                let newAmiiboObj = AmiiboObj(amiiboObj: apiAmiibo)
                modelContext.insert(newAmiiboObj)
            }
        }
        //try modelContext.save() // Consider auto-save, but explicit for this example
    }

    func addFavorite(_ amiibo: AmiiboObj) throws {
        amiibo.isFavorite = true
        // No hay necesidad de insertar porque el elemento ya existe en el contexto, solo se modifica la propiedad y se guarda automaticamente. Si no se guardara se puede acudir a:
       // try modelContext.save()
    }
    
    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) throws {
        for index in offsets {
            modelContext.delete(amiibos[index])
        }
        //try modelContext.save()
    }
    
    func deleteFavorite(id: String, in favs: [AmiiboObj]) throws { 
        if let amiiboToDelete = favs.first(where: { $0.id == id }) {
        modelContext.delete(amiiboToDelete)
      }
        //try modelContext.save()
    }
    
    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) throws {
        for index in offsets {
            modelContext.delete(favs[index])
        }
        //try modelContext.save()
    }
    
    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj] {
         let descriptor = FetchDescriptor<AmiiboObj>(predicate: #Predicate { $0.isFavorite == isFavorite }, sortBy: [SortDescriptor(\.name)])
         return try modelContext.fetch(descriptor)
     }
}

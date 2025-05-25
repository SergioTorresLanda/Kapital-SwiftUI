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
    
    private let remoteDataSource: RemoteAmiiboDataSourceProtocol
    private let localDataSource: LocalAmiiboDataSourceProtocol

    //Guarda el contexto. Esta es la capa entre el almacén de persistencia y los objetos en la memoria.
    private let url = URL(string: "https://www.amiiboapi.com/api/amiibo/")

    init(remoteDataSource: RemoteAmiiboDataSourceProtocol, localDataSource: LocalAmiiboDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchAndPersistAmiibos() async throws {
        let apiAmiibos = try await remoteDataSource.fetchAmiibosFromAPI()
        try localDataSource.insertOrUpdate(amiibos: apiAmiibos)
    }
    
    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) {
        try? localDataSource.deleteAmiibos(at: offsets, in: amiibos)
    }

    func addFavorite(_ amiibo: AmiiboObj) {
        try? localDataSource.addFavorite(amiibo)
    }

    func deleteFavorite(id: String, in favs: [AmiiboObj]) {
        try? localDataSource.deleteFavorite(id: id, in: favs)
    }

    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) {
        try? localDataSource.deleteFavorites(at: offsets, in: favs)
    }

    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj] {
        return try localDataSource.getAmiibos(isFavorite: isFavorite)
     }
}


//
//  MyViewModel.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class MyViewModel {
    
    private let repository: AmiiboRepositoryProtocol // Injeccion de dependencia abstracta
    var amiibos: [AmiiboObj] = [] //data pública guardada localmente
    var favs: [AmiiboObj] = [] //favoritos guardados localmente
    private(set) var isLoading = false //propiedad para menejar el estado del ActivityIndicator
    
    //Se inyecta el contexto al inicializarse el viewmodel
    init(repository:AmiiboRepositoryProtocol) {
         self.repository = repository
         fetchAmiibos() //recuperar Data offline
     }
    
    func fetchData() async throws {
       isLoading = true
       defer { isLoading = false }
       try await repository.fetchAndPersistAmiibos()
       fetchAmiibos() // Refresh ViewModel's lists after persistence
       fetchFavs()
   }
    // MARK: Actualizar la propiedad que vera la vista, usando de la data guardada en local como fuente de verdad.
    func fetchAmiibos() {
        do {
            amiibos = try repository.getAmiibos(isFavorite: false)
        } catch {
            print("Fallo la busqueda de Amiibos: \(error.localizedDescription)")
            amiibos = []
        }
    }
    func fetchFavs() {
        do {
            favs = try repository.getAmiibos(isFavorite: true)
        } catch {
            print("Fallo la busqueda de Favoritos: \(error.localizedDescription)")
            favs = []
        }
    }
    
    // MARK: PERSISTENCIA DE LA DATA REGULAR
    // Eliminar elementos
    func deleteAmiibos(at offsets: IndexSet) {
        repository.deleteAmiibos(at: offsets, in: amiibos)
        fetchAmiibos()
    }
    // MARK: PERSISTENCIA DE FAVORITOS
    //Agregar favoritos
    func addFavoriteToSD(with amiibo: AmiiboObj){
        repository.addFavorite(amiibo)
        fetchFavs()
    }
    // Eliminar favoritos
    func deleteFavoriteFromSD(id: String) {
        repository.deleteFavorite(id: id, in: favs)
        fetchFavs()
    }
    
    func deleteFavoriteFromIndex(at offsets: IndexSet) {
        repository.deleteFavorites(at: offsets, in: favs)
        fetchFavs()
    }

}

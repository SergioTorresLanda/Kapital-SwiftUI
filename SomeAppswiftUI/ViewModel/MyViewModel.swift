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

    private var modelContext: ModelContext //Guarda el contexto. Esta es la capa entre el almacén de persistencia y los objetos en la memoria.
    private let repository: AmiiboRepositoryProtocol // Injected dependency
    var amiibos: [AmiiboObj] = [] //data pública guardada localmente
    var favs: [AmiiboObj] = [] //favoritos guardados localmente

    private(set) var isLoading = false //propiedad para menejar el estado del ActivityIndicator
    let url = URL(string: "https://www.amiiboapi.com/api/amiibo/")
    
    //Se inyecta el contexto al inicializarse el viewmodel
    init(modelContext: ModelContext, repository:AmiiboRepositoryProtocol) {
         self.modelContext = modelContext
         self.repository = repository
         //fetchAmiibos()
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
            amiibos = []
        }
    }
    
    // MARK: PERSISTENCIA DE LA DATA REGULAR
    // Agregar elementos
    func addItemToSD(with: Amiibo){
        let item = AmiiboObj(amiiboObj:with)
        modelContext.insert(item)
        fetchAmiibos()
    }
    // Eliminar elementos
    func deleteAmiibos(at offsets: IndexSet) {
        for index in offsets {
            let amiiboToDelete = amiibos[index]
            modelContext.delete(amiiboToDelete)
        }
        fetchAmiibos()
    }
    // MARK: PERSISTENCIA DE FAVORITOS
    //Agregar favoritos
    func addFavoriteToSD(with amiibo: AmiiboObj){
        amiibo.isFavorite = true
        modelContext.insert(amiibo)
        fetchFavs()
    }
    // Eliminar favoritos
    func deleteFavoriteFromSD(id: String) {
        guard let index = favs.firstIndex(where: { $0.id==id }) else {return}
        let amiiboToDelete = favs[index]
        modelContext.delete(amiiboToDelete)
        fetchFavs()
    }
    
    func deleteFavoriteFromIndex(at offsets: IndexSet) {
        for index in offsets {
            let amiiboToDelete = favs[index]
            modelContext.delete(amiiboToDelete)
        }
        fetchFavs()
    }

}

//
//  SomeAppswiftUITests.swift
//  SomeAppswiftUITests
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import XCTest
import SwiftData
@testable import SomeAppswiftUI

final class MyViewModelTests: XCTestCase {
    
      var viewModel: MyViewModel!
      var mockRemoteDataSource: MockRemoteAmiiboDataSource!
      var mockLocalDataSource: MockLocalAmiiboDataSource!
      var amiiboRepository: AmiiboRepositoryProtocol!

    override func setUpWithError() throws {
        // Se Crea un almacén en memoria para cada prueba (util si la simulación de LocalDataSource usa internamente un ModelContext real o si se quiere verificar el comportamiento de persistencia a través de la simulación).
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AmiiboObj.self, configurations: config)
 
        mockRemoteDataSource = MockRemoteAmiiboDataSource()
        mockLocalDataSource = MockLocalAmiiboDataSource()
        // InicializarAmiiboRepository con DataSource mocks
        amiiboRepository = AmiiboRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource)
        // Inicializar VM con este AmiiboRepository
        viewModel = MyViewModel(repository: amiiboRepository)
    }

    override func tearDownWithError() throws {
       viewModel = nil
       mockRemoteDataSource = nil
       mockLocalDataSource = nil
       amiiboRepository = nil
    }
    
    func testService() async throws {
        // Given: El mockRemoteDataSource regresa el dummy amiibo
        mockRemoteDataSource.amiibosToReturn = [.dummy]

        // When: Se busca data
        try await viewModel.fetchData()

        // Then: El array del Vm debe tener el dummy amiibo
        XCTAssertFalse(viewModel.amiibos.isEmpty, "ViewModel amiibos should not be empty")
        XCTAssertEqual(viewModel.amiibos.count, 1, "ViewModel should have 1 amiibo")
        XCTAssertEqual(viewModel.amiibos.first?.name, Amiibo.dummy.name, "The fetched amiibo should be the dummy one")
    }
    
    func testAddAndFetchFavorite() async throws {
        // Given: Dado un dummy amiibo que va a ser agregado a favoritos
       let amiiboToAdd = AmiiboObj(amiiboObj: .dummy)
       // Llenar el mock de Data local con el dummy
       try mockLocalDataSource.insertOrUpdate(amiibos: [Amiibo.dummy])
       // When: Lo agregamos a favoritos..
       viewModel.addFavoriteToSD(with: amiiboToAdd)
       // Then:
       // 1. EL mockDataSource local debe reflejar el cambio
       XCTAssertTrue(mockLocalDataSource.storedAmiibos.first(where: { $0.id == amiiboToAdd.id })?.isFavorite ?? false, "Amiibo should be marked as favorite in mock local storage")
       
       // 2. El ViewModel's favs array debe contener este amiibo
       XCTAssertFalse(viewModel.favs.isEmpty, "Favorites list should not be empty")
       XCTAssertEqual(viewModel.favs.first?.id, amiiboToAdd.id, "Favorite list should contain the added amiibo")
      
  }
    
    func testDeleteFavorite() async throws {
        // Given:
        let amiiboToDelete = AmiiboObj(amiiboObj: .dummy)
        amiiboToDelete.isFavorite = true
        
        mockLocalDataSource.storedAmiibos.append(amiiboToDelete)
        
        viewModel.fetchFavs()
        XCTAssertFalse(viewModel.favs.isEmpty, "Favorites list should not be empty initially")
        
        // When:
        viewModel.deleteFavoriteFromSD(id: amiiboToDelete.id)

        // Then:
        XCTAssertTrue(mockLocalDataSource.storedAmiibos.filter({ $0.isFavorite ?? false }).isEmpty, "Amiibo should be deleted from mock local favorites storage")

        XCTAssertTrue(viewModel.favs.isEmpty, "Favorites list should be empty after deletion")
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockRemoteAmiiboDataSource: RemoteAmiiboDataSourceProtocol {
    var amiibosToReturn: [Amiibo] = [.dummy] // Default dummy data
    var shouldThrowError: Bool = false

    func fetchAmiibosFromAPI() async throws -> [Amiibo] {
        if shouldThrowError {
            throw URLError(.badServerResponse) // Example error
        }
        return amiibosToReturn
    }
}

// Mock for Local Data Source
class MockLocalAmiiboDataSource: LocalAmiiboDataSourceProtocol {
    // Este mock simula el comportamiento de  persistencia para testear el ViewModel..
    var storedAmiibos: [AmiiboObj] = []

    func insertOrUpdate(amiibos: [Amiibo]) throws {
        amiibos.forEach { apiAmiibo in
            if let _ = storedAmiibos.firstIndex(where: { $0.name == apiAmiibo.name }) {
            } else {
                let newAmiiboObj = AmiiboObj(amiiboObj: apiAmiibo)
                storedAmiibos.append(newAmiiboObj)
            }
        }
    }

    func addFavorite(_ amiibo: AmiiboObj) throws {
        if let index = storedAmiibos.firstIndex(where: { $0.id == amiibo.id }) {
            storedAmiibos[index].isFavorite = true
        } else {
            //Si aun no esta guardado por este mock, agregalo y guardalo como favorito
            let newAmiiboObj = amiibo
            newAmiiboObj.isFavorite = true
            storedAmiibos.append(newAmiiboObj)
        }
    }

    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) throws {
        storedAmiibos.remove(atOffsets: offsets)
    }
    
    func deleteFavorite(id: String, in favs: [AmiiboObj]) throws {
        if let index = storedAmiibos.firstIndex(where: { $0.id == id }) {
            storedAmiibos.remove(at: index)
        }
    }
    
    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) throws {
        storedAmiibos.remove(atOffsets: offsets)
    }

    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj] {
        return storedAmiibos.filter { ($0.isFavorite ?? false) == isFavorite }
    }
}



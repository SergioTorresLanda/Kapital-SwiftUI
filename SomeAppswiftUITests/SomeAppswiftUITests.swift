//
//  SomeAppswiftUITests.swift
//  SomeAppswiftUITests
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import XCTest
import SwiftData
@testable import SomeAppswiftUI

final class SomeAppswiftUITests: XCTestCase {
    
    var modelContext: ModelContext!
    var viewModel: MyViewModel!
    var repository: AmiiboRepositoryProtocol!
    var remoteDataSource: RemoteAmiiboDataSourceProtocol!
    var localDatasource: LocalAmiiboDataSourceProtocol!

    override func setUpWithError() throws {
        // Create an in-memory store for each test
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AmiiboObj.self, configurations: config)
        modelContext = ModelContext(container)
        
        // Use a real AmiiboRepository with the in-memory context for this test
        // (You might mock this too if you only want to test ViewModel logic, not persistence)
        
        repository = MockDataService(modelContext:modelContext) // Assuming AmiiboRepository init with ModelContext
        viewModel = MyViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        modelContext = nil
        viewModel = nil
        repository = nil    }

    func testExample() throws {
        //Given
        //When

    }
    
    func testService() async throws {
        //Given
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AmiiboObj.self, configurations: config)
        let users = [Amiibo.dummy]
        //When
        let mockService = MockDataService(modelContext: ModelContext(container))
        let vm = MyViewModel(repository: mockService)
        try await vm.fetchData()
        //Then
        XCTAssertFalse(vm.amiibos.isEmpty)
    }
    
    func testAddAndFetchFavorite() async throws {
      // Given: An amiibo object (not yet favorited)
      let amiibo = AmiiboObj(amiiboObj: .dummy) // Your AmiiboObj dummy
      XCTAssertFalse(amiibo.isFavorite ?? true, "Amiibo should initially not be a favorite")

      // Insert the amiibo into the context so it can be managed
      modelContext.insert(amiibo)

      // When: We add it to favorites via the ViewModel
      viewModel.addFavoriteToSD(with: amiibo) // This sets isFavorite and fetches favs

        // Then:
        // 1. The original amiibo object's favorite status should be true
        XCTAssertTrue(amiibo.isFavorite ?? false, "AmiiboObj should be marked as favorite")
        
        // 2. The ViewModel's favs list should contain this amiibo
        XCTAssertFalse(viewModel.favs.isEmpty, "Favorites list should not be empty")
        XCTAssertEqual(viewModel.favs.first?.id, amiibo.id, "Favorite list should contain the added amiibo") //Failing test
        
        // 3. The main amiibos list should still contain it (if it wasn't filtered)
        XCTAssertFalse(viewModel.amiibos.isEmpty, "Main list should not be empty")
        XCTAssertEqual(viewModel.amiibos.first?.id, amiibo.id, "Main list should still contain the amiibo") //Failing test
  }
    
    func testDeleteFavorite() async throws {
        // Given: A favorited amiibo already in the context and ViewModel's favs list
        let amiibo = AmiiboObj(amiiboObj: .dummy)
        amiibo.isFavorite = true // Manually set as favorite
        modelContext.insert(amiibo)
        
        // Refresh ViewModel's state
        viewModel.fetchFavs()
        XCTAssertFalse(viewModel.favs.isEmpty, "Favorites list should not be empty initially")
        
        // When: We delete it from favorites
        viewModel.deleteFavoriteFromSD(id: amiibo.id) // This deletes from persistence

        // Then: The ViewModel's favs list should be empty
        XCTAssertTrue(viewModel.favs.isEmpty, "Favorites list should be empty after deletion")
        
        // Verify it's actually deleted from the persistence layer
     //   let descriptor = FetchDescriptor<AmiiboObj>(predicate: #Predicate { $0.id == amiibo.id })
        //Failing here: Cannot convert value of type 'PredicateExpressions.Equal<PredicateExpressions.KeyPath<PredicateExpressions.Variable<AmiiboObj>, String>, PredicateExpressions.KeyPath<PredicateExpressions.Value<AmiiboObj>, String>>' to closure result type 'any StandardPredicateExpression<Bool>'
       // let fetchedAmiibos = try modelContext.fetch(descriptor)
     //   XCTAssertTrue(fetchedAmiibos.isEmpty, "Amiibo should be deleted from the persistence store")
     
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockDataService: AmiiboRepositoryProtocol {
   // private let remoteDataSource: RemoteAmiiboDataSourceProtocol
   // private let localDataSource: LocalAmiiboDataSourceProtocol
    let modelContext : ModelContext
    let mockAmiiboObj = AmiiboObj(amiiboObj: .dummy)

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchAndPersistAmiibos() async throws {
        modelContext.insert(mockAmiiboObj)
    }
    
    func addFavorite(_ amiibo: AmiiboObj) {
        amiibo.isFavorite=true
    }
    
    func deleteAmiibos(at offsets: IndexSet, in amiibos: [AmiiboObj]) {
        for index in offsets {
            modelContext.delete(amiibos[index])
        }
    }
    
    func deleteFavorite(id: String, in favs: [AmiiboObj]) {
        if let amiiboToDelete = favs.first(where: { $0.id == id }) {
            modelContext.delete(amiiboToDelete)
      }
    }
    
    func deleteFavorites(at offsets: IndexSet, in favs: [AmiiboObj]) {
        for index in offsets {
            modelContext.delete(favs[index])
        }
    }
    
    func getAmiibos(isFavorite: Bool) throws -> [AmiiboObj] {
        return [mockAmiiboObj]
    }
}



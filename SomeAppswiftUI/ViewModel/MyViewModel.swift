//
//  MyViewModel.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation

final class MyViewModel: ObservableObject {
    
    @Published private(set) var cards: [Amiibo] = []
    @Published private(set) var isLoading = false
    let url = URL(string: "https://www.amiiboapi.com/api/amiibo/")
    
    func deleteCard(at offsets: IndexSet) {
         cards.remove(atOffsets: offsets)
         print("Tarjeta eliminada en los índices: \(offsets)")
     }

}

class MockDataService: MockDataServiceProtocol {
    let cards: [Amiibo]
    init (cards:[Amiibo]?){
        self.cards = cards ?? []
    }
    
    func fetchData() async throws {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
        }
    }
}

extension MyViewModel : MockDataServiceProtocol {
    
    func fetchData() async throws {
        isLoading=true
        defer { isLoading = false }
        
        guard let apiURL = url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        //request.timeoutInterval = 20 // request config not needed
        //request.setValue("Bearer \(tksession ?? "")", forHTTPHeaderField: "Authorization")// request config not needed
        let (data, response) = try await URLSession.shared.data(for: request)
        // Check response status code
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // Could consider creating a more specific error type here
            throw NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }
        
        let decoder = JSONDecoder()
        let resp = try decoder.decode(AmiiboResp.self, from: data)
        self.cards = resp.amiibo
    }
}

protocol MockDataServiceProtocol {
    func fetchData() async throws
}

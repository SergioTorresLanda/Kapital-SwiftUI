//
//  RemoteAmiiboDataSource.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 24/05/25.
// Handles network

import Foundation

protocol RemoteAmiiboDataSourceProtocol {
    func fetchAmiibosFromAPI() async throws -> [Amiibo]
}

class RemoteAmiiboDataSource: RemoteAmiiboDataSourceProtocol {
    
    private let apiURL = URL(string: "https://www.amiiboapi.com/api/amiibo/")
    
    func fetchAmiibosFromAPI() async throws -> [Amiibo] {
        guard let url = apiURL else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let resp = try JSONDecoder().decode(AmiiboResp.self, from: data)
        return resp.amiibo
    }
}

//
//  AmiiboModel.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation

struct AmiiboResp: Codable {
    var amiibo: [Amiibo]
}

struct Amiibo: Codable {
    var amiiboSeries: String
    var character: String
    var gameSeries: String
    var head: String
    var image: String
    var name: String
    var release: Release
    var tail: String
    var type: String
}

struct Release: Codable {
    var au: String?
    var eu: String?
    var jp: String?
    var na: String?
}

extension Amiibo {
    static var dummy: Amiibo {
        .init(amiiboSeries: "dummy Ammibo Series",
              character: "dummy character",
              gameSeries: "dummy gameSeries",
              head: "dummy head",
              image: "https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_04380001-03000502.png",
              name: "dummy name",
              release: Release(au: "dummy au", eu: "dummy eu", jp: "dummy jp", na: "dummy na"),
              tail: "dummy tail",
              type: "dummy String")
    }
}

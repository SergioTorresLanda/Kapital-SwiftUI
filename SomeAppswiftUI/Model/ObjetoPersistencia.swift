//
//  ObjetoPersistencia.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 24/05/25.
//

import Foundation
import SwiftData

@Model
class AmiiboObj: Identifiable {
    var id : String
    var isFavorite : Bool?
    var amiiboSeries: String
    var character: String
    var gameSeries: String
    var head: String
    var image: String
    var name: String
    var release: Release
    var tail: String
    var type: String
    
    init(amiiboObj: Amiibo) {
        id = UUID().uuidString
        isFavorite = false
        self.amiiboSeries = amiiboObj.amiiboSeries
        self.character = amiiboObj.character
        self.gameSeries = amiiboObj.gameSeries
        self.head = amiiboObj.head
        self.image = amiiboObj.image
        self.name = amiiboObj.name
        self.release = amiiboObj.release
        self.tail = amiiboObj.tail
        self.type = amiiboObj.type
    }
}

extension AmiiboObj {
    static var dummy: AmiiboObj {
        .init(amiiboObj: .dummy)
    }
}

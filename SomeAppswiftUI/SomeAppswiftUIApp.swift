//
//  SomeAppswiftUIApp.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import SwiftUI
import SwiftData

@main
struct SomeAppswiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: AmiiboObj.self)
        //aqui se crea el contenedor que persiste la Data localmente.
    }
}

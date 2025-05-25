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
    
    let container: ModelContainer
    
    init() {
        do {
            // Revisa los launch arguments para resetear la data (si es UITest)
            if CommandLine.arguments.contains("-resetSwiftData") {
                let path = URL.applicationSupportDirectory.appending(path: "default.store")
                // Borra el archivo en memoria si existe
                if FileManager.default.fileExists(atPath: path.path) {
                    try FileManager.default.removeItem(at: path)
                    print("SwiftData store reset for UI testing.")
                }
            }

            //Crea el contenedor
            container = try ModelContainer(for: AmiiboObj.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(container)
        //aqui se pega el contenedor que persiste la Data localmente a la ventana-escena-app-contexto global.
    }
}

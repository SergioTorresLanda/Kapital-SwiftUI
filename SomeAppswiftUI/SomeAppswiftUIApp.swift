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
            // Check for UI test launch argument to reset data
            if CommandLine.arguments.contains("-resetSwiftData") {
                let path = URL.applicationSupportDirectory.appending(path: "default.store")
                // Delete the store file if it exists
                if FileManager.default.fileExists(atPath: path.path) {
                    try FileManager.default.removeItem(at: path)
                    print("SwiftData store reset for UI testing.")
                }
            }

            // Then create your container
            container = try ModelContainer(for: AmiiboObj.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(container)
        //aqui se crea el contenedor que persiste la Data localmente.
    }
}

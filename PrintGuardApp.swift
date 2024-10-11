//
//  PrintGuardApp.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 24.08.2024.
//

import SwiftUI
import SwiftData
import SwiftSnmpKit

//@StateObject var cloudKitModel = CloudKitModel()


@main
struct PrintGuardApp: App {
    
    
    // Der ModelContainer ist eine Art Datenbank-Verwaltungseinheit, die alle in der App verwendeten Datenmodelle und deren Konfigurationen verwaltet.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Printer.self,
        ]) // Ein Schema enthält alle Datenmodelle meiner App
        
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false) // Konigurationsinstanz für den Modelcontainer. Die Modelkonfiguration gibt an, wie und wo das Modell gespeichert werden soll.
        // Schema: Übergibt das definierte Schema an den ModelContainer, sodass er weiss, welche Datenmodelle er verwalten soll.
        // "isStoredInMemoryOnly": Gibt an, ob die Daten nur im Speicher (RAM) oder auch in der Festplatte gespeichert werden sollen.

        
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }() // das "()" bedeutet, dass das "Computing" direkt nach der Definition der Variabel beginnt

    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 978, maxWidth: 978, minHeight: 478, maxHeight: 478)
                .modelContainer(for: [Printer.self])
                
                
        }
        .modelContainer(sharedModelContainer)
        .windowResizability(.contentSize)
    }
}

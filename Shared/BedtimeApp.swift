//
//  BedtimeApp.swift
//  Shared
//
//  Created by Michael Thingnes on 19/02/21.
//

import SwiftUI

@main
struct BedtimeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

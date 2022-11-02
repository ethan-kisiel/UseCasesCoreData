//
//  UseCasesCoreDataApp.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//

import SwiftUI

@main
struct UseCasesCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  StudyAppApp.swift
//  StudyApp
//
//  Created by Yohan Yoon on 8/29/25.
//

import SwiftUI
import SwiftData

@main
struct StudyAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TimerManager.self, CycleCountManager.self, CycleItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .background(Color("CustomColor1"))
        }
        .modelContainer(sharedModelContainer)
    }
}

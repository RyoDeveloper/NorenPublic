//
//  NorenApp.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

@main
struct NorenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PlanManager())
        }
    }
}

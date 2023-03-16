//
//  ContentView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var planManager: PlanManager
    // アプリの起動回数
    @AppStorage("LaunchCount") var count = 0
    @State var requestCalendar = false
    @State var requestReminder = false

    var body: some View {
        NavigationView()
            .alert("カレンダーへのアクセスが許可されていません", isPresented: $requestCalendar, actions: {
                Button("設定を開く") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            })
            .alert("リマインダーへのアクセスが許可されていません", isPresented: $requestReminder, actions: {
                Button("設定を開く") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            })
            .task {
                if count != 0 {
                    count += 1
                    requestCalendar = !planManager.requestCalendar()
                    requestReminder = !planManager.requestReminder()
                } else {
                    count += 1
                    print(planManager.requestCalendar())
                    print(planManager.requestReminder())
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  SettingsView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var planManager: PlanManager
    @State var viewModel = SettingsViewModel()

    var body: some View {
        List {
            Section("アクセス") {
                HStack {
                    Text("カレンダー")
                    Spacer()
                    if planManager.requestCalendar() {
                        Label("利用可能", systemImage: "checkmark.circle")
                            .labelStyle(.titleAndIcon)
                    } else {
                        Button {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            Label("設定を開く", systemImage: "exclamationmark.triangle")
                                .labelStyle(.titleAndIcon)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                HStack {
                    Text("リマインダー")
                    Spacer()
                    if planManager.requestReminder() {
                        Label("利用可能", systemImage: "checkmark.circle")
                            .labelStyle(.titleAndIcon)
                    } else {
                        Button {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            Label("設定を開く", systemImage: "exclamationmark.triangle")
                                .labelStyle(.titleAndIcon)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            Section("サポート") {
                HStack {
                    Text("最新情報")
                    Spacer()

                    Link(destination: viewModel.twitterURL) {
                        Label("ブラウザで開く", systemImage: "safari")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderless)
                }
                HStack {
                    Text("使い方")
                    Spacer()

                    Link(destination: viewModel.userGuideURL) {
                        Label("ブラウザで開く", systemImage: "safari")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderless)
                }
                HStack {
                    Text("プライバシーポリシー")
                    Spacer()
                    Link(destination: viewModel.privacyPolicyURL) {
                        Label("ブラウザで開く", systemImage: "safari")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .navigationTitle("設定")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(PlanManager())
        }
    }
}

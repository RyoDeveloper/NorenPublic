//
//  ReminderView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

enum ReminderPage {
    case board
    case grid
}

struct ReminderView: View {
    @State var page = ReminderPage.board
    @State var isShowCreatePlanView = false

    var body: some View {
        Group {
            switch page {
            case .board:
                BoardReminderView()
            case .grid:
                GridReminderView()
            }
        }
        .sheet(isPresented: $isShowCreatePlanView, content: {
            CreatePlanView(type: .reminder)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Picker("", selection: $page) {
                    Text("ボード")
                        .tag(ReminderPage.board)
                    Text("グリッド")
                        .tag(ReminderPage.grid)
                }
                .pickerStyle(.segmented)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowCreatePlanView = true
                } label: {
                    Label("新規", systemImage: "plus")
                }
            }
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}

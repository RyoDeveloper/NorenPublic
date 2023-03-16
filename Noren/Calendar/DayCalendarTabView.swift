//
//  DayCalendarTabView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

enum DayCalendarTabPage {
    case calendar
    case markdown
}

struct DayCalendarTabView: View {
    @EnvironmentObject var planManager: PlanManager
    @State var page = DayCalendarTabPage.calendar
    @Binding var date: Date
    @State var note = ""
    @State var isShowCreatePlanView = false

    var body: some View {
        TabView(selection: $page) {
            ScrollView {
                DayCalendarListView(date: $date)
                    .padding()
            }
            .tabItem {
                Label("カレンダー", systemImage: "calendar")
            }
            MarkdownView(note: $note)
                .onChange(of: note) { newValue in
                    let noteEvent = planManager.fetchNote(date: date)
                    noteEvent.notes = newValue
                    planManager.createNote(event: noteEvent)
                }
                .tabItem {
                    Label("ノート", systemImage: "square.and.pencil")
                }
        }
        .task {
            note = planManager.fetchNote(date: date).notes ?? ""
        }
        .onChange(of: date) { _ in
            note = planManager.fetchNote(date: date).notes ?? ""
        }
    }
}

struct DayCalendarTabView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarTabView(date: .constant(Date()))
    }
}

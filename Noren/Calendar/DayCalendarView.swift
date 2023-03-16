//
//  DayCalendarView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct DayCalendarView: View {
    @EnvironmentObject var planManager: PlanManager
    @Binding var date: Date
    @State var note = ""

    var body: some View {
        HStack {
            ScrollView {
                DayCalendarListView(date: $date)
                    .padding()
            }
            Divider()
            MarkdownView(note: $note)
                .onChange(of: note) { newValue in
                    let noteEvent = planManager.fetchNote(date: date)
                    noteEvent.notes = newValue
                    planManager.createNote(event: noteEvent)
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

struct DayCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarView(date: .constant(Date()))
    }
}

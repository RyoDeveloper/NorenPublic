//
//  BoardReminderView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct BoardReminderView: View {
    @EnvironmentObject var planManager: PlanManager

    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(planManager.store.sources, id: \.self) { source in
                        ForEach(Array(source.calendars(for: .reminder)), id: \.self) { calendar in
                            CalendarReminderListView(calendar: calendar)
                                .frame(width: 250, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct BoardReminderView_Previews: PreviewProvider {
    static var previews: some View {
        BoardReminderView()
            .environmentObject(PlanManager())
    }
}

//
//  GridReminderView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct GridReminderView: View {
    @EnvironmentObject var planManager: PlanManager
    @State var columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(planManager.store.sources, id: \.self) { source in
                    ForEach(Array(source.calendars(for: .reminder)), id: \.self) { calendar in
                        CalendarReminderListView(calendar: calendar)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
            }
            .padding()
        }
    }
}

struct GridReminderView_Previews: PreviewProvider {
    static var previews: some View {
        GridReminderView()
            .environmentObject(PlanManager())
    }
}

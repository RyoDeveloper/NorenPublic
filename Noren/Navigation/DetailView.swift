//
//  DetailView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @Binding var page: NavigationPage?
    @Binding var date: Date

    var body: some View {
        switch page ?? .calendar {
        case .calendar:
            CalendarView(date: $date)
        case .reminder:
            ReminderView()
        case .settings:
            SettingsView()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(page: .constant(.calendar), date: .constant(Date()))
    }
}

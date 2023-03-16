//
//  SidebarView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

enum NavigationPage: CaseIterable {
    case calendar
    case reminder
    case settings
}

struct SidebarView: View {
    @Binding var page: NavigationPage?
    @Binding var date: Date

    var body: some View {
        List(selection: $page) {
            Button {
                date = Date()
            } label: {
                Text(Date().getDateDayOfWeek())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .buttonStyle(.plain)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .onChange(of: date) { _ in
                    page = .calendar
                }
            NavigationLink(value: NavigationPage.calendar) {
                Label("カレンダー", systemImage: "calendar")
            }
            NavigationLink(value: NavigationPage.reminder) {
                Label("リマインダー", systemImage: "checkmark.circle")
            }
            NavigationLink(value: NavigationPage.settings) {
                Label("設定", systemImage: "gearshape")
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(page: .constant(.calendar), date: .constant(Date()))
    }
}

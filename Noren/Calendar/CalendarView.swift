//
//  CalendarView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

enum CalendarPage {
    case day
    case week
}

struct CalendarView: View {
    @Binding var date: Date
    @State var page = CalendarPage.day
    @State var isShowCreatePlanView = false

    var body: some View {
        Group {
            switch page {
            case .day:
                if UIDevice.current.userInterfaceIdiom == .phone {
                    DayCalendarTabView(date: $date)
                }else {
                    DayCalendarView(date: $date)
                }
            case .week:
                WeekCalendarView(date: $date)
            }
        }
        .sheet(isPresented: $isShowCreatePlanView, content: {
            CreatePlanView(type: .event)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Picker("", selection: $page) {
                    Text("日")
                        .tag(CalendarPage.day)
                    Text("週")
                        .tag(CalendarPage.week)
                }
                .pickerStyle(.segmented)
            }
            ToolbarItem(placement: .principal) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CalendarView(date: .constant(Date()))
        }
    }
}

//
//  CalendarReminderListView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import EventKit
import SwiftUI

struct CalendarReminderListView: View {
    @EnvironmentObject var PlanManager: PlanManager
    @State var calendar: EKCalendar
    // 期限切れ
    @State var expiredPlans: [Plan] = []
    // 今日
    @State var todayPlans: [Plan] = []
    // 明日
    @State var tomorrowPlans: [Plan] = []
    // 明後日
    @State var dayAfterTomorrowPlans: [Plan] = []
    // 以降
    @State var onwardsPlans: [Plan] = []
    // 期限なし
    @State var indefinitePlans: [Plan] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text(calendar.title)
                .font(.title)
                .fontWeight(.semibold)
            Section {
                ForEach(expiredPlans, id: \.self) { plan in
                    PlanView(plan: plan)
                }
                .padding(.leading)
            } header: {
                HStack {
                    Text("期限切れ: \(expiredPlans.count)")
                        .foregroundColor(expiredPlans.isEmpty ? Color.gray : Color.primary)
                }
            }
            Section {
                ForEach(todayPlans, id: \.self) { plan in
                    PlanView(plan: plan)
                        .padding(.leading)
                }
            } header: {
                Text("今日: \(todayPlans.count)")
                    .foregroundColor(todayPlans.isEmpty ? Color.gray : Color.primary)
            }
            Section {
                ForEach(tomorrowPlans, id: \.self) { plan in
                    PlanView(plan: plan)
                        .padding(.leading)
                }
            } header: {
                Text("明日: \(tomorrowPlans.count)")
                    .foregroundColor(tomorrowPlans.isEmpty ? Color.gray : Color.primary)
            }
            Section {
                ForEach(dayAfterTomorrowPlans, id: \.self) { plan in
                    PlanView(plan: plan)
                        .padding(.leading)
                }
            } header: {
                Text("明後日: \(dayAfterTomorrowPlans.count)")
                    .foregroundColor(dayAfterTomorrowPlans.isEmpty ? Color.gray : Color.primary)
            }
            Section {
                ForEach(onwardsPlans, id: \.self) { plan in
                    PlanView(plan: plan)
                        .padding(.leading)
                }
            } header: {
                Text("以降: \(onwardsPlans.count)")
                    .foregroundColor(onwardsPlans.isEmpty ? Color.gray : Color.primary)
            }
            Section {
                ForEach(indefinitePlans, id: \.self) { plan in
                    PlanView(plan: plan)
                        .padding(.leading)
                }
            } header: {
                Text("日時設定なし: \(indefinitePlans.count)")
                    .foregroundColor(indefinitePlans.isEmpty ? Color.gray : Color.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.primary.opacity(0.05))
        .cornerRadius(10)
        .task {
            expiredPlans = PlanManager.fetchReminder(start: Calendar.current.date(byAdding: .year, value: -1, to: Date())!, end: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, calendar: [calendar])
            todayPlans = PlanManager.fetchReminder(start: Date(), end: Date(), calendar: [calendar])
            tomorrowPlans = PlanManager.fetchReminder(start: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, end: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, calendar: [calendar])
            dayAfterTomorrowPlans = PlanManager.fetchReminder(start: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, end: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, calendar: [calendar])
            onwardsPlans = PlanManager.fetchReminder(start: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, end: Calendar.current.date(byAdding: .year, value: 1, to: Date())!, calendar: [calendar])
            indefinitePlans = PlanManager.fetchReminder(calendar: [calendar])
        }
    }
}

struct CalendarReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderListView(calendar: EKCalendar(for: .reminder, eventStore: PlanManager().store))
            .environmentObject(PlanManager())
    }
}

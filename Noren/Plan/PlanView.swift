//
//  PlanView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var planManager: PlanManager
    @State var plan: Plan
    var date: Date?
    @State var isShowCreatePlanView = false

    var body: some View {
        Group {
            if let event = plan.event {
                // イベント
                HStack {
                    ZStack {
                        Image(systemName: "circle")
                            .fontWeight(.bold)
                            .foregroundColor(Color.clear)
                        Image(systemName: "poweron")
                            .fontWeight(.bold)
                            .foregroundColor(plan.getCalendarColor())
                    }
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .lineLimit(2)
                        if !event.isAllDay {
                            Text(event.startDate.getPlanDate(date: date) + " ~ " + event.endDate.getPlanDate(date: date))
                                .font(.footnote)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
                }
            } else if let reminder = plan.reminder {
                // リマインダー
                HStack {
                    Image(systemName: "circle")
                        .fontWeight(.bold)
                        .foregroundColor(plan.getCalendarColor())
                    VStack {
                        Text(reminder.title)
                            .lineLimit(2)
                        if let hour = reminder.dueDateComponents?.hour, let minute = reminder.dueDateComponents?.minute {
                            Text("\(hour):" + String(format: "%02d", minute))
                                .font(.footnote)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.primary.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            if let event = plan.event {
                if event.calendar.allowsContentModifications {
                    isShowCreatePlanView = true
                }
            } else if let reminder = plan.reminder {
                if reminder.calendar.allowsContentModifications {
                    isShowCreatePlanView = true
                }
            }
        }
        .contextMenu(menuItems: {
            Button(role: .destructive) {
                planManager.removePlan(plan: plan)
            } label: {
                Label("削除", systemImage: "trash")
            }
        })
        .sheet(isPresented: $isShowCreatePlanView) {
            CreatePlanView(plan: plan)
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(plan: Plan(PlanManager()))
            .environmentObject(PlanManager())
    }
}

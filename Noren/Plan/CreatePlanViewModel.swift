//
//  CreatePlanViewModel.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import EventKit
import Foundation

class CreatePlanViewModel: ObservableObject {
    var currentEvent: EKEvent?
    var currentReminder: EKReminder?
    // タイトル
    @Published var title = ""
    // 終日
    @Published var isAllDay = false
    // 開始日時
    @Published var start = Date()
    // 終了日時
    @Published var end = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    // カレンダー
    @Published var calendar: EKCalendar?
    // URL
    @Published var url = ""
    // ノート
    @Published var note = ""
    // 日付
    @Published var isDay = false
    // 優先順位
    @Published var priority = 2
    
    func createPlan(planManager: PlanManager, type: EKEntityType) {
        let planTitles = title.split(whereSeparator: \.isNewline)
        
        if type == .event {
            // イベントの追加
            planTitles.forEach { title in
                let event = currentEvent ?? EKEvent(eventStore: planManager.store)
                if let currentReminder {
                    // リマインダーからイベントへ変更
                    planManager.removePlan(plan: Plan(currentReminder))
                }
                
                event.title = String(title)
                event.isAllDay = isAllDay
                event.startDate = start
                event.endDate = end
                event.calendar = calendar ?? planManager.store.defaultCalendarForNewEvents
                event.url = URL(string: url)
                event.notes = note
                planManager.createPlan(plan: Plan(event))
            }
        } else if type == .reminder {
            // リマインダーの追加
            planTitles.forEach { title in
                let reminder = currentReminder ?? EKReminder(eventStore: planManager.store)
                if let currentEvent {
                    // イベントからリマインダーへ変更
                    planManager.removePlan(plan: Plan(currentEvent))
                }
                
                reminder.title = String(title)
                if isDay && isAllDay {
                    reminder.dueDateComponents = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: start)
                } else if isDay {
                    reminder.dueDateComponents = Calendar.current.dateComponents([.calendar, .year, .month, .day, .hour, .minute], from: start)
                }
                reminder.priority = priority.getPriority()
                reminder.calendar = calendar ?? planManager.store.defaultCalendarForNewReminders()
                reminder.url = URL(string: url)
                reminder.notes = note
                planManager.createPlan(plan: Plan(reminder))
            }
        }
    }
}

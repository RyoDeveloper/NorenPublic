//
//  Plan.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import EventKit
import Foundation
import SwiftUI

struct Plan: Hashable {
    var event: EKEvent?
    var reminder: EKReminder?
    var date: Date?

    init(_ event: EKEvent) {
        self.event = event
        self.reminder = nil
        self.date = event.startDate
    }

    init(_ reminder: EKReminder) {
        self.reminder = reminder
        self.event = nil
        self.date = reminder.dueDateComponents?.date
    }

    /// Debug用サンプルデータ
    init(_ planManager: PlanManager) {
        let debugCalendar = EKCalendar(for: .event, eventStore: planManager.store)
        debugCalendar.cgColor = CGColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)

        let debugEvent = EKEvent(eventStore: planManager.store)
        debugEvent.title = "EventTitle"
        debugEvent.startDate = Date()
        debugEvent.endDate = Date()
        debugEvent.calendar = debugCalendar
        self.event = debugEvent
        self.date = debugEvent.startDate
    }
}

extension Plan {
    func getCalendarColor() -> Color {
        if let event = self.event {
            return Color(event.calendar.cgColor)
        } else if let reminder = self.reminder {
            return Color(reminder.calendar.cgColor)
        }
        return Color(.systemBrown)
    }
}

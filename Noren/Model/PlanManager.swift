//
//  PlanManager.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import EventKit
import Foundation

class PlanManager: ObservableObject {
    var store = EKEventStore()
    var noteKeyWord = "@NorenDay"
    
    /// カレンダーへのアクセスを要求
    func requestCalendar() -> Bool {
        Task {
            do {
                // カレンダーへのアクセスを要求
                try await store.requestAccess(to: .event)
            } catch {
                print(error.localizedDescription)
            }
        }
        // イベントへの認証ステータス
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            // カレンダーへのアクセスする権限が選択されていません。
            return false
        case .restricted:
            // カレンダーへのアクセスする権限がありません。
            return false
        case .denied:
            // カレンダーへのアクセスが明示的に拒否されています。
            return false
        case .authorized:
            // カレンダーへのアクセスが許可されています。
            return true
        @unknown default:
            // @unknown default
            return false
        }
    }
    
    /// リマインダーへのアクセスを要求
    func requestReminder() -> Bool {
        Task {
            do {
                // リマインダーへのアクセスを要求
                try await store.requestAccess(to: .reminder)
            } catch {
                print(error.localizedDescription)
            }
        }
        // リマインダーへの認証ステータス
        let status = EKEventStore.authorizationStatus(for: .reminder)
        
        switch status {
        case .notDetermined:
            // リマインダーへのアクセスする権限が選択されていません。
            return false
        case .restricted:
            // リマインダーへのアクセスする権限がありません。
            return false
        case .denied:
            // リマインダーへのアクセスが明示的に拒否されています。
            return false
        case .authorized:
            // リマインダーへのアクセスが許可されています。
            return true
        @unknown default:
            // @unknown default
            return false
        }
    }
    
    /// イベントの取得
    func fetchEvent(start: Date, end: Date, calendar: [EKCalendar]?) -> [Plan] {
        var plans: [Plan] = []
        // 開始日コンポーネントの作成
        // 指定した日付の0:00:0
        let start = Calendar.current.startOfDay(for: start)
        // 終了日コンポーネントの作成
        // 指定した日付の23:59:1
        let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 1, of: end)
        // イベントストアのインスタンスメソッドから述語を作成
        var predicate: NSPredicate?
        if let end {
            predicate = store.predicateForEvents(withStart: start, end: end, calendars: calendar)
        }
        // 述語に一致する全てのイベントを取得
        if let predicate {
            store.events(matching: predicate).forEach { event in
                if event.title != noteKeyWord {
                    plans.append(Plan(event))
                }
            }
        }
        return plans
    }
    
    /// リマインダーの取得
    func fetchReminder(start: Date, end: Date, calendar: [EKCalendar]?) -> [Plan] {
        let semaphore = DispatchSemaphore(value: 0)
        var plans: [Plan] = []
        // 開始日コンポーネントの作成
        // 指定した前の日付の23:59:59
        let start = Calendar.current.date(byAdding: .second, value: -1, to: Calendar.current.startOfDay(for: start))
        // 終了日コンポーネントの作成
        // 指定した日付の23:59:0
        let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: Calendar.current.startOfDay(for: end))
        // イベントストアのインスタンスメソッドから述語を作成
        var predicate: NSPredicate?
        predicate = store.predicateForIncompleteReminders(withDueDateStarting: start, ending: end, calendars: calendar)
        // 述語に一致する全てのリマインダーを取得
        if let predicate {
            store.fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    reminders.forEach { reminder in
                        plans.append(Plan(reminder))
                    }
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return plans
    }
    
    /// リマインダーの取得(日付指定なし)
    func fetchReminder(calendar: [EKCalendar]?) -> [Plan] {
        let semaphore = DispatchSemaphore(value: 0)
        var plans: [Plan] = []
        // イベントストアのインスタンスメソッドから述語を作成
        var predicate: NSPredicate?
        predicate = store.predicateForReminders(in: calendar)
        // 述語に一致する全てのリマインダーを取得
        if let predicate {
            store.fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    reminders.forEach { reminder in
                        if reminder.dueDateComponents == nil && reminder.isCompleted == false {
                            plans.append(Plan(reminder))
                        }
                    }
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return plans
    }
    
    /// イベントとリマインダーの取得
    func fetchEventAndReminder(start: Date, end: Date, calendar: [EKCalendar]?) -> [Plan] {
        var plans: [Plan] = []
        fetchEvent(start: start, end: end, calendar: calendar).forEach { plan in
            plans.append(plan)
        }
        fetchReminder(start: start, end: end, calendar: calendar).forEach { plan in
            plans.append(plan)
        }
        // 時間順に並び替え
        plans.sort(by: { a, b -> Bool in
            a.date ?? Date() < b.date ?? Date()
        })
        return plans
    }
    
    /// プランの追加
    func createPlan(plan: Plan) {
        if let event = plan.event {
            // イベントの追加
            do {
                try store.save(event, span: .thisEvent, commit: true)
            } catch {
                print(error.localizedDescription)
            }
        } else if let reminder = plan.reminder {
            // リマインダーの追加
            do {
                try store.save(reminder, commit: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// プランの削除
    func removePlan(plan: Plan) {
        if let event = plan.event {
            // イベントの追加
            do {
                try store.remove(event, span: .thisEvent, commit: true)
            } catch {
                print(error.localizedDescription)
            }
        } else if let reminder = plan.reminder {
            // リマインダーの追加
            do {
                try store.remove(reminder, commit: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// ノートの取得
    func fetchNote(date: Date) -> EKEvent {
        var event = EKEvent(eventStore: store)
        event.title = noteKeyWord
        event.startDate = date
        event.endDate = date
        event.isAllDay = true
        event.calendar = store.defaultCalendarForNewEvents
        // 開始日コンポーネントの作成
        // 指定した日付の0:00
        let start = Calendar.current.startOfDay(for: date)
        // 終了日コンポーネントの作成
        // 指定した日付の23:59:1
        let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 1, of: start)
        // イベントストアのインスタンスメソッドから述語を作成
        var predicate: NSPredicate?
        if let end {
            predicate = store.predicateForEvents(withStart: start, end: end, calendars: [store.defaultCalendarForNewEvents ?? EKCalendar(for: .event, eventStore: store)])
        }
        // 述語に一致する全てのイベントを取得
        if let predicate {
            store.events(matching: predicate).forEach { _event in
                if _event.title == noteKeyWord, _event.isAllDay {
                    event = _event
                }
            }
        }
        return event
    }
    
    /// ノートの追加
    func createNote(event: EKEvent) {
        if !(event.notes?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
            createPlan(plan: Plan(event))
        } else {
            removePlan(plan: Plan(event))
        }
    }
}

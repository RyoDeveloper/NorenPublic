//
//  CreatePlanView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import EventKit
import SwiftUI

struct CreatePlanView: View {
    @EnvironmentObject var planManager: PlanManager
    @StateObject var viewModel = CreatePlanViewModel()
    @State var type: EKEntityType = .event
    @State var plan: Plan?
    // 親ViewのSheetのフラグ
    @Environment(\.dismiss) var dismiss
    // 追加するイベント・リマインダーの個数
    @State var planCount = 0

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $type) {
                    Text("イベント")
                        .tag(EKEntityType.event)
                    Text("リマインダー")
                        .tag(EKEntityType.reminder)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                if type == .event {
                    // イベント
                    Form {
                        TextField("タイトル", text: $viewModel.title, axis: .vertical)
                        Toggle("終日", isOn: $viewModel.isAllDay)
                        DatePicker("開始", selection: $viewModel.start, displayedComponents: viewModel.isAllDay ? .date : [.date, .hourAndMinute])
                            .onChange(of: viewModel.start) { newValue in
                                if newValue > viewModel.end {
                                    viewModel.end = newValue
                                }
                            }
                        DatePicker("終了", selection: $viewModel.end, displayedComponents: viewModel.isAllDay ? .date : [.date, .hourAndMinute])
                            .onChange(of: viewModel.end) { newValue in
                                if newValue < viewModel.start {
                                    viewModel.start = newValue
                                }
                            }
                        Picker("カレンダー", selection: $viewModel.calendar) {
                            ForEach(planManager.store.sources, id: \.self) { sources in
                                Section(sources.title) {
                                    ForEach(Array(sources.calendars(for: .event)), id: \.self) { calendar in
                                        if calendar.allowsContentModifications {
                                            Text(calendar.title)
                                                .tag(calendar as EKCalendar?)
                                        }
                                    }
                                }
                            }
                        }
                        .task {
                            viewModel.calendar = planManager.store.defaultCalendarForNewEvents
                        }
                        HStack {
                            TextField("URL", text: $viewModel.url)
                            PasteButton(payloadType: URL.self) { url in
                                DispatchQueue.main.async {
                                    viewModel.url = url[0].absoluteString
                                }
                            }
                            .labelStyle(.iconOnly)
                        }
                        TextField("メモ", text: $viewModel.note, axis: .vertical)
                            .frame(minHeight: 100, alignment: .topLeading)
                    }
                } else {
                    // リマインダー
                    Form {
                        TextField("タイトル", text: $viewModel.title, axis: .vertical)
                        Toggle("日付", isOn: $viewModel.isDay)
                        if viewModel.isDay {
                            Toggle("終日", isOn: $viewModel.isAllDay)
                            DatePicker("日付", selection: $viewModel.start, displayedComponents: viewModel.isAllDay ? .date : [.date, .hourAndMinute])
                        }
                        HStack {
                            Text("優先順位")
                            Spacer()
                            ForEach(0 ..< 3) { index in
                                Button {
                                    // 選択済みをもう一度タップで初期化
                                    if viewModel.priority == index + 1 {
                                        viewModel.priority = 0
                                    } else {
                                        viewModel.priority = index + 1
                                    }
                                } label: {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(index < viewModel.priority ? Color.accentColor : Color(.quaternaryLabel))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        Picker("リスト", selection: $viewModel.calendar) {
                            ForEach(planManager.store.sources, id: \.self) { sources in
                                Section(sources.title) {
                                    ForEach(Array(sources.calendars(for: .reminder)), id: \.self) { reminder in
                                        if reminder.allowsContentModifications {
                                            Text(reminder.title)
                                                .tag(reminder as EKCalendar?)
                                        }
                                    }
                                }
                            }
                        }
                        .task {
                            viewModel.calendar = planManager.store.defaultCalendarForNewReminders()
                        }
                        HStack {
                            TextField("URL", text: $viewModel.url)
                            PasteButton(payloadType: URL.self) { url in
                                DispatchQueue.main.async {
                                    viewModel.url = url[0].absoluteString
                                }
                            }
                            .labelStyle(.iconOnly)
                        }
                        TextField("メモ", text: $viewModel.note, axis: .vertical)
                            .frame(minHeight: 100, alignment: .topLeading)
                    }
                }
            }
            .task {
                if let plan {
                    // プランの変更
                    if let event = plan.event {
                        type = .event
                        viewModel.currentEvent = event
                        viewModel.title = event.title
                        viewModel.isAllDay = event.isAllDay
                        viewModel.start = event.startDate
                        viewModel.end = event.endDate
                        viewModel.calendar = event.calendar
                        viewModel.url = event.url?.absoluteString ?? ""
                        viewModel.note = event.notes ?? ""
                    } else if let reminder = plan.reminder {
                        type = .reminder
                        viewModel.currentReminder = reminder
                        viewModel.title = reminder.title
                        if let dueDate = reminder.dueDateComponents {
                            viewModel.isDay = true
                            if dueDate.minute == nil {
                                viewModel.isAllDay = true
                            }
                            viewModel.start = reminder.dueDateComponents?.date ?? Date()
                        }
                        viewModel.calendar = reminder.calendar
                        viewModel.url = reminder.url?.absoluteString ?? ""
                        viewModel.note = reminder.notes ?? ""
                        viewModel.priority = reminder.priority.getNum()
                    }
                }
            }
            .onChange(of: viewModel.title, perform: { newValue in
                planCount = newValue.split(whereSeparator: \.isNewline).count
            })
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル", role: .destructive) {
                        dismiss()
                    }
                    .buttonStyle(.borderless)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("追加") {
                        viewModel.createPlan(planManager: planManager, type: type)
                        dismiss()
                    }
                    .disabled(planCount == 0)
                }
            }
            .navigationTitle("\(planCount)個の" + type.getEntityName())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreatePlanView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlanView()
            .environmentObject(PlanManager())
    }
}

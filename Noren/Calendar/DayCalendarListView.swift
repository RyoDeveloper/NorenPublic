//
//  DayCalendarListView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct DayCalendarListView: View {
    @EnvironmentObject var planManager: PlanManager
    @StateObject var viewModel = DayCalendarListViewModel()
    @Binding var date: Date
    @State var plans: [Plan] = []

    var body: some View {
        VStack {
            ForEach(plans, id: \.self) { plan in
                PlanView(plan: plan, date: date)
            }
        }
        .frame(maxWidth: .infinity)
        .onChange(of: date, perform: { newValue in
            plans = planManager.fetchEventAndReminder(start: newValue, end: newValue, calendar: nil)
        })
        .task {
            plans = planManager.fetchEventAndReminder(start: date, end: date, calendar: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(viewModel.fetchEvent), name: .EKEventStoreChanged, object: planManager.store)
        }
    }
}

struct DayCalendarListView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarListView(date: .constant(Date()))
            .environmentObject(PlanManager())
    }
}

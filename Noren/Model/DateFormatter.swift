//
//  DateFormatter.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import Foundation

extension Date {
    /// 2023年2月16日 9時41分 1秒の場合
    
    /// 9:41
    func getHourMinutes() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    /// 2023年2月16日9:41
    func getAAHourMinutes() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    /// 2023年2月16日木曜日
    func getDateDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    /// 21(必ず24時間表記になる)
    func getHH() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        // formatter.locale = NSLocale.system
        return Int(formatter.string(from: self)) ?? 0
    }
    
    /// 16
    func getd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    func getPlanDate(date: Date?) -> String {
        if let date {
            if Calendar.current.isDate(self, equalTo: date, toGranularity: .day) {
                return self.getHourMinutes()
            }
        }
        return self.getAAHourMinutes()
    }
}

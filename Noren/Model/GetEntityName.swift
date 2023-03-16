//
//  GetEntityName.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import EventKit
import Foundation

extension EKEntityType {
    func getEntityName() -> String {
        switch self {
        case .event:
            return "イベント"
        case .reminder:
            return "リマインダー"
        @unknown default:
            return ""
        }
    }
}

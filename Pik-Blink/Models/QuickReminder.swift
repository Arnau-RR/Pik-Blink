//
//  QuickReminder.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Foundation
import SwiftUI

enum QuickReminder: CaseIterable {
    case thirtyMinutes
    case oneHour
    case twoHours
    case custom

    var title: LocalizedStringKey {
        switch self {
        case .thirtyMinutes: "+ 30m"
        case .oneHour: "+ 1h"
        case .twoHours: "+ 2h"
        case .custom: "new.item.time.custom"
        }
    }

    var icon: String {
        switch self {
        case .thirtyMinutes, .oneHour, .twoHours:
            return "clock"
        case .custom:
            return "calendar"
        }
    }
}

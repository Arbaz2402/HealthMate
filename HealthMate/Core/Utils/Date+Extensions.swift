//
//  Date+Extensions.swift
//  HealthMate
//

import Foundation

extension Calendar {
    static let app: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar
    }()
}

extension Date {
    var startOfDayLocal: Date { Calendar.app.startOfDay(for: self) }
    var endOfDayLocal: Date {
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        return Calendar.app.date(byAdding: comps, to: startOfDayLocal) ?? self
    }
}



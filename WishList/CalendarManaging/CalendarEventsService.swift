//
//  CalendarEventsService.swift
//  WishList
//
//  Created by Egor Kolobaev on 16.03.2025.
//

import Foundation

protocol CalendarEventsService {
    func create(eventModel: CalendarEventModel) -> Bool
}

struct CalendarEventModel {
    var title: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

extension WishEventDataModel {
    var calendarEvent: CalendarEventModel {
        CalendarEventModel(title: title, startDate: startDate, endDate: endDate, note: description)
    }
}

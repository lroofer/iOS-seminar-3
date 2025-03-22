//
//  WishEventModel.swift
//  WishList
//
//  Created by Egor Kolobaev on 16.03.2025.
//

import Foundation

extension WishEventModel {
    var startDate: Date {
        Date(timeIntervalSince1970: startDateTimeStamp)
    }
    var endDate: Date {
        Date(timeIntervalSince1970: startDateTimeStamp)
    }
}

struct WishEventDataModel {
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date

    func fill(_ model: WishEventModel) {
        model.title = title
        model.wishDescription = description
        model.startDateTimeStamp = startDate.timeIntervalSince1970
        model.endDateTimeStamp = endDate.timeIntervalSince1970
    }
}

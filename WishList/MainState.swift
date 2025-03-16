//
//  MainState.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import Combine

/// **MainState** is a special class that stores the state of the program using Publishers
final class MainState {
    @Published private(set) var edittingValue: String

    init() {
        self.edittingValue = ""
    }

    func setCustomInEditField(value: String) {
        edittingValue = value
    }
}

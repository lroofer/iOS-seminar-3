//
//  ColorChangable.swift
//  WishList
//
//  Created by Егор Колобаев on 05.11.2024.
//

import Combine
import UIKit

protocol ColorChangable: UIView {
  var color: PassthroughSubject<UIColor, Never> { get }
  var name: String { get }
  func set(to: UIColor)
}

//
//  SlidersView.swift
//  WishList
//
//  Created by Егор Колобаев on 05.11.2024.
//

import UIKit
import Combine

final class SlidersView: UIStackView, ColorChangable {
  private let red = CustomSlider(title: .red, minValue: .sliderMin, maxValue: .sliderMax)
  private let green = CustomSlider(title: .green, minValue: .sliderMin, maxValue: .sliderMax)
  private let blue = CustomSlider(title: .blue, minValue: .sliderMin, maxValue: .sliderMax)

  private var cancellables = Set<AnyCancellable>()

  private(set) var color: PassthroughSubject<UIColor, Never> = .init()

  let name = "Sliders"

  func set(to color: UIColor) {
    let ciColor = CIColor(color: color)
    red.force(to: Float(ciColor.red))
    green.force(to: Float(ciColor.green))
    blue.force(to: Float(ciColor.blue))
  }

  private func observe() {
    Publishers.CombineLatest3(red.$value, green.$value, blue.$value)
      .sink { [weak self] (r, g, b) in
        self?.color.send(
          UIColor(
            red: CGFloat(r),
            green: CGFloat(g),
            blue: CGFloat(b),
            alpha: 1
          )
        )
      }
      .store(in: &cancellables)
  }

  private func configureUI() {
    axis = .vertical
    layer.cornerRadius = .stackRadius
    clipsToBounds = true
    for slider in [red, green, blue] {
      addArrangedSubview(slider)
    }
  }

  init(color: UIColor) {
    super.init(frame: .zero)
    set(to: color)
    configureUI()
    observe()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension Double {
  static let sliderMin: Self = 0
  static let sliderMax: Self = 1
}

private extension String {
  static let red = "Red"
  static let green = "Green"
  static let blue = "Blue"
}

private extension CGFloat {
  static let stackRadius: Self = 20
}

//
//  CustomSlider.swift
//  WishList
//
//  Created by Егор Колобаев on 05.11.2024.
//

import UIKit

final class CustomSlider: UIView {
  @Published private(set) var value: Float

  private let titleView = UILabel()
  private let slider = UISlider()

  func force(to value: Float) {
    slider.value = value
  }

  private func configureUI() {
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false

    for view in [slider, titleView] {
      addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    titleView.textColor = .black

    NSLayoutConstraint.activate([
      titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

      slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
      slider.centerXAnchor.constraint(equalTo: centerXAnchor),
      slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
    ])
  }

  @objc
  private func changeValue() {
    value = slider.value
  }

  init(title: String, minValue: Double, maxValue: Double) {
    self.value = Float(minValue)
    super.init(frame: .zero)

    titleView.text = title
    slider.value = value
    slider.minimumValue = Float(minValue)
    slider.maximumValue = Float(maxValue)
    slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)

    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

//
//  ColorPicker.swift
//  RandomColor
//
//  Created by Егор Колобаев on 05.11.2024.
//

import UIKit
import Combine

final class RandomColor: UIButton, ColorChangable {
  private(set) var color: PassthroughSubject<UIColor, Never>

  let name = "Random"

  func configureUI() {
    setTitle("Press for random color", for: .normal)
    titleLabel?.textColor = .white
    layer.cornerRadius = 10
    clipsToBounds = true
    backgroundColor = .systemBlue
    addTarget(self, action: #selector(generateRandom), for: .touchUpInside)
  }

  func set(to newColor: UIColor) {
    color.send(newColor)
  }

  @objc
  private func generateRandom() {
    let r = CGFloat.random(in: 0..<1)
    let g = CGFloat.random(in: 0..<1)
    let b = CGFloat.random(in: 0..<1)
    color.send(.init(red: r, green: g, blue: b, alpha: 1))
  }

  init(color: UIColor) {
    self.color = .init()
    super.init(frame: .zero)

    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

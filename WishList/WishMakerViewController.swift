//
//  ViewController.swift
//  WishList
//
//  Created by Егор Колобаев on 05.11.2024.
//

import UIKit
import Combine

final class WishMakerViewController: UIViewController {
  private var cancellables = Set<AnyCancellable>()
  private var views = [ColorChangable]()
  private lazy var segmentedControl = UISegmentedControl(items: views.map { $0.name })

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemPink
    configureUI()
    observe()
  }

  private func observe() {
    for item in views {
      item.color
        .sink { [weak self] color in
          self?.view.backgroundColor = color
        }
        .store(in: &cancellables)
    }
  }

  private func configureUI() {
    views = [
      SlidersView(color: view.backgroundColor ?? .blue),
      RandomColor(color: view.backgroundColor ?? .blue)
    ]
    configureTitles()
    configureControls()
  }

  private func configureTitles() {
    let title = UILabel()
    let subtitle = UILabel()
    title.text = "WishMaker"
    title.font = .systemFont(ofSize: 32, weight: .medium)
    subtitle.text = "Move sliders to change the background color"
    subtitle.font = .systemFont(ofSize: 20)

    subtitle.numberOfLines = 0
    subtitle.lineBreakMode = .byWordWrapping

    title.translatesAutoresizingMaskIntoConstraints = false
    subtitle.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(title)
    view.addSubview(subtitle)

    segmentedControl.addTarget(self, action: #selector(changedTheView), for: .valueChanged)

    view.addSubview(segmentedControl)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    changedTheView()

    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      title.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),

      subtitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
      subtitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

      segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      segmentedControl.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 30)
    ])
  }

  private func configureControls() {
    for subView in views {
      view.addSubview(subView)
      subView.isHidden = true
      subView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        subView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leading),
        subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottom)
      ])
    }
    changedTheView()
  }

  @objc
  private func changedTheView() {
    for index in views.indices {
      if index == segmentedControl.selectedSegmentIndex {
        views[index].set(to: view.backgroundColor ?? .blue)
        views[index].isHidden = false
      } else {
        views[index].isHidden = true
      }
    }
  }

}

private extension CGFloat {
  static let bottom: Self = -40
  static let leading: Self = 20
}

//
//  ViewController.swift
//  WishList
//
//  Created by Егор Колобаев on 05.11.2024.
//

import UIKit
import Combine

final class WishMakerViewController: UIViewController {
    // MARK: - Properties
    private let addWishButton: UIButton = UIButton(type: .system)

    private var cancellables = Set<AnyCancellable>()
    private var views = [ColorChangable]()
    private lazy var segmentedControl = UISegmentedControl(
        items: views.map { $0.name }
    )

    // MARK: - Methods

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
        configureAddWishButton()
        configureControls()
    }

    private func configureTitles() {
        let title = UILabel()
        let subtitle = UILabel()
        title.text = "WishMaker"
        title.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        subtitle.text = "Move sliders to change the background color"
        subtitle.font = .systemFont(ofSize: Constants.subtitleFontSize)

        subtitle.numberOfLines = .zero
        subtitle.lineBreakMode = .byWordWrapping

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(title)
        view.addSubview(subtitle)

        segmentedControl.addTarget(self, action: #selector(changedTheView), for: .valueChanged)

        view.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        changedTheView()

        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leading),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopAnchor),

            subtitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constants.subtitleTopAnchor),
            subtitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leading),

            segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: Constants.segmentedTopAnchor)
        ])
    }

    private func configureAddWishButton() {
        view.addSubview(addWishButton)

        addWishButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addWishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addWishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
            addWishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bottom),
            addWishButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])

        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.buttonText, for: .normal)

        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }

    private func configureControls() {
        for subView in views {
            view.addSubview(subView)
            subView.isHidden = true
            subView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
                subView.bottomAnchor.constraint(equalTo: addWishButton.topAnchor, constant: Constants.sliderBottomAnchor)
            ])
        }
        changedTheView()
    }

    @objc
    private func addWishButtonPressed() {
        print("Pressed")
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

private enum Constants {
    static let bottom: CGFloat = -40
    static let leading: CGFloat = 20
    static let titleTopAnchor: CGFloat = 30
    static let subtitleTopAnchor: CGFloat = 20
    static let segmentedTopAnchor: CGFloat = 30
    static let titleFontSize: CGFloat = 32
    static let subtitleFontSize: CGFloat = 32
    static let buttonHeight: CGFloat = 40
    static let buttonRadius: CGFloat = 10
    static let sliderBottomAnchor: CGFloat = -40

    static let buttonText: String = "My wishes"
}

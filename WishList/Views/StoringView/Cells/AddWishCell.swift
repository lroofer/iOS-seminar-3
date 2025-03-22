//
//  AddWishCell.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit
import Combine

final class AddWishCell: UITableViewCell {

    // MARK: - Properties
    static let reuseId: String = "AddWishCell"

    private let textView: UITextView = UITextView()
    private let saveButton: UIButton = UIButton(type: .system)
    private let shareButton: UIButton = UIButton(type: .system)

    private weak var state: MainState?
    private var addWish: ((String) -> ())?
    private var shareAction: (() -> ())?
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(
        state: MainState,
        addWish: @escaping (String) -> (),
        shareAction: @escaping () -> ()
    ) {
        self.addWish = addWish
        self.shareAction = shareAction
        self.state = state

        // Subscribe to the value using Combine
        state.$edittingValue.sink { [weak self] value in
            self?.textView.text = value
        }.store(in: &cancellables)
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        configureTextView()
        configureSaveButton()
        configureShareButton()
    }

    private func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: Constants.fontSize)
        textView.textColor = .black
        textView.backgroundColor = .cyan
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = Constants.borderWidth
        textView.layer.cornerRadius = Constants.cornerRadius
        addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.horizontalPadding.negative),
            textView.heightAnchor.constraint(equalToConstant: Constants.textHeight)
        ])
    }

    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle(Constants.saveButtonText, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Constants.cornerRadius
        saveButton.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.verticalSpacing),
            saveButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func configureShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle(Constants.shareButtonText, for: .normal)
        shareButton.backgroundColor = .systemRed
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.layer.cornerRadius = Constants.cornerRadius
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        addSubview(shareButton)

        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: Constants.verticalSpacing),
            shareButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            shareButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.verticalSpacing.negative),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func addWishButtonTapped() {
        guard let text = textView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        addWish?(text)
        textView.text = ""
    }

    @objc private func shareButtonTapped() {
        shareAction?()
    }
}

private enum Constants {
    static let fontSize: CGFloat = 16
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 8
    static let textHeight: CGFloat = 35
    static let verticalSpacing: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
    static let buttonWidth: CGFloat = 100
    static let buttonHeight: CGFloat = 40

    static let saveButtonText: String = "Save Wish"
    static let shareButtonText: String = "Share"
}



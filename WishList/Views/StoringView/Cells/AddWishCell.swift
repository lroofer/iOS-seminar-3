//
//  AddWishCell.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit

final class AddWishCell: UITableViewCell {

    static let reuseId: String = "AddWishCell"

    private let textView: UITextView = UITextView()
    private let button: UIButton = UIButton(type: .system)

    private var addWish: ((String) -> ())?

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

    func setAddWishMethod(_ addWish: @escaping (String) -> ()) {
        self.addWish = addWish
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        configureTextView()
        configureButton()
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

    private func configureButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.buttonText, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.verticalSpacing),
            button.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.verticalSpacing.negative),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func addWishButtonTapped() {
        guard let text = textView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        addWish?(text)
        textView.text = ""
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

    static let buttonText: String = "Add Wish"
}



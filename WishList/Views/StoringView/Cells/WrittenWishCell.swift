//
//  WrittenWishCell.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId: String = "WrittenWishCell"

    private let wrap: UIView = UIView()
    private let wishLabel: UILabel = UILabel()
    private let editButton: UIButton = UIButton(type: .system)
    private let removeButton: UIButton = UIButton(type: .system)

    private var onRemove: (() -> ())?
    private var onEdit: (() -> ())?

    // MARK: - Lifecycle
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

    // MARK: - Functions

    func configure(with wish: String, onEdit: @escaping () -> (), onRemove: @escaping () -> ()) {
        wishLabel.text = wish
        self.onRemove = onRemove
        self.onEdit = onEdit
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear

        addSubview(wrap)

        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius

        wrap.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: topAnchor, constant: Constants.wrapOffSetV),
            wrap.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.wrapOffSetV.negative),
            wrap.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.wrapOffSetH),
            wrap.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.wrapOffSetH.negative),
            wrap.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.wrapHeight)
        ])
        configureLabel()
        configureRemoveButton()
        configureEditButton()
    }

    private func configureLabel() {
        wrap.addSubview(wishLabel)
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wishLabel.centerXAnchor.constraint(equalTo: wrap.centerXAnchor),
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.wishLabelOffset),
            wishLabel.leadingAnchor.constraint(greaterThanOrEqualTo: wrap.leadingAnchor, constant: Constants.wishLabelOffset)
        ])
    }

    private func configureEditButton() {
        editButton.setBackgroundImage(.actions, for: .normal)
        editButton.addTarget(self, action: #selector(onEditTapped), for: .touchUpInside)
        wrap.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: Constants.buttonSpacing.negative),
            editButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            editButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            editButton.centerYAnchor.constraint(equalTo: wrap.centerYAnchor)
        ])
    }

    private func configureRemoveButton() {
        removeButton.setBackgroundImage(.remove, for: .normal)
        removeButton.addTarget(self, action: #selector(onRemoveTapped), for: .touchUpInside)
        wrap.addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeButton.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: Constants.wrapOffSetH.negative),
            removeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            removeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            removeButton.centerYAnchor.constraint(equalTo: wrap.centerYAnchor)
        ])
    }

    @objc
    private func onEditTapped() {
        onEdit?()
    }

    @objc
    private func onRemoveTapped() {
        onRemove?()
    }

}

private enum Constants {
    static let wrapColor: UIColor = .white
    static let wrapRadius: CGFloat = 16
    static let wrapOffSetV: CGFloat = 5
    static let wrapOffSetH: CGFloat = 10
    static let wishLabelOffset: CGFloat = 8
    static let wrapHeight: CGFloat = 40
    static let buttonSpacing: CGFloat = 20
    static let buttonSize: CGFloat = 24
}

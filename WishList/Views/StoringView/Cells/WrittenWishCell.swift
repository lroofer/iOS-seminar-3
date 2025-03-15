//
//  WrittenWishCell.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    static let reuseId: String = "WrittenWishCell"
    private let wishLabel: UILabel = UILabel()

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

    func configure(with wish: String) {
        wishLabel.text = wish
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear

        let wrap: UIView = UIView()
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

        wrap.addSubview(wishLabel)

        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wishLabel.centerXAnchor.constraint(equalTo: wrap.centerXAnchor),
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.wishLabelOffset),
            wishLabel.leadingAnchor.constraint(greaterThanOrEqualTo: wrap.leadingAnchor, constant: Constants.wishLabelOffset)
        ])
    }

}

private enum Constants {
    static let wrapColor: UIColor = .white
    static let wrapRadius: CGFloat = 16
    static let wrapOffSetV: CGFloat = 5
    static let wrapOffSetH: CGFloat = 10
    static let wishLabelOffset: CGFloat = 8
    static let wrapHeight: CGFloat = 40
}

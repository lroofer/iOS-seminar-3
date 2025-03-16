//
//  WishEventCell.swift
//  WishList
//
//  Created by Egor Kolobaev on 16.03.2025.
//

import UIKit

final class WishEventCell: UICollectionViewCell {
    // MARK: - Constants
    static let reuseIdentifier: String = "WishEventCell"

    private let stack: UIStackView = UIStackView()
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureWrap()
        configureStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cell Configuration
    func configure(with event: WishEventModel) {
        titleLabel.text = event.title
        descriptionLabel.text = event.desciption
        startDateLabel.text = "Start Date: \(event.startDate.formatted(date: .numeric, time: .shortened))"
        endDateLabel.text = "End Date: \(event.endDate.formatted(date: .numeric, time: .shortened))"
    }

    // MARK: - UI Configuration
    private func configureWrap() {
        addSubview(wrapView)

        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.backgroundColor = Constants.backgroundColor
        wrapView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        wrapView.layer.borderWidth = Constants.borderWidth

        wrapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.offset),
            wrapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset),
            wrapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: Constants.offset.negative)
        ])
    }

    private func configureStack() {
        stack.axis = .vertical
        wrapView.addSubview(stack)
        stack.spacing = Constants.spacing

        for subView in [
            titleLabel,
            descriptionLabel,
            startDateLabel,
            endDateLabel
        ] {
            stack.addArrangedSubview(subView)
        }

        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: wrapView.topAnchor, constant: Constants.stackTop),
            stack.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.leading),
            stack.bottomAnchor.constraint(equalTo: wrapView.bottomAnchor, constant: Constants.stackTop.negative),
            stack.centerXAnchor.constraint(equalTo: wrapView.centerXAnchor),
        ])
    }

    private func configureTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = Constants.titleFont

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
    }

    private func configureDescriptionLabel() {
        descriptionLabel.textColor = .systemGray4
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.numberOfLines = 4
        descriptionLabel.textAlignment = .left

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: Constants.descriptionMaxHeight)
        ])
    }

    private func configureStartDateLabel() {
        startDateLabel.textColor = .systemBlue
        startDateLabel.font = Constants.dateFont

        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDateLabel.heightAnchor.constraint(equalToConstant: Constants.dateHeight)
        ])
    }

    private func configureEndDateLabel() {
        endDateLabel.textColor = .systemRed
        endDateLabel.font = Constants.dateFont

        endDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            endDateLabel.heightAnchor.constraint(equalToConstant: Constants.dateHeight)
        ])
    }
}

private enum Constants {
    static let offset: CGFloat = 10
    static let cornerRadius: CGFloat = 20
    static let stackTop: CGFloat = 10
    static let leading: CGFloat = 15
    static let spacing: CGFloat = 15
    static let wrapHeight: CGFloat = 200
    static let titleHeight: CGFloat = 30
    static let descriptionMaxHeight: CGFloat = 40
    static let dateHeight: CGFloat = 25


    static let backgroundColor: UIColor = .secondarySystemBackground
    static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    static let descriptionFont: UIFont = .systemFont(ofSize: 12)
    static let dateFont: UIFont = .systemFont(ofSize: 14)

    static let borderWidth: CGFloat = 1
}

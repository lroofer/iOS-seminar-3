//
//  WishStoringViewController.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit
import Combine

final class WishStoringViewController: UIViewController {

    private let table: UITableView = UITableView(frame: .zero)
    private let defaults = UserDefaults.standard
    private let state: MainState = MainState()
    private var wishArray: [String] = []

    override func viewDidLoad() {
        view.backgroundColor = .blue
        if let values = defaults.array(forKey: Constants.wishesKey) as? [String] {
            wishArray = values
        }
        configureTable()
    }

    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .red
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius

        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            table.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableTopOffset),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.tableBottomOffset)
        ])

        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }

    private func add(value: String) {
        wishArray.append(value)
        defaults.set(wishArray, forKey: Constants.wishesKey)
    }

    @discardableResult
    private func remove(index: Int) -> String {
        guard index < wishArray.count else {
            return ""
        }

        defer {
            defaults.set(wishArray, forKey: Constants.wishesKey)
        }

        return wishArray.remove(at: index)
    }
}

extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case .zero:
            Constants.firstSectionRows
        default:
            wishArray.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.numberOfSections
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case .zero:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddWishCell.reuseId,
                for: indexPath
            )

            guard let wishCell = cell as? AddWishCell else {
                return cell
            }

            wishCell.contentView.isUserInteractionEnabled = false

            wishCell.configure(state: state) { [weak self] wish in
                self?.add(value: wish)
                tableView.reloadData()
            }

            return wishCell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WrittenWishCell.reuseId,
                for: indexPath
            )

            guard let wishCell = cell as? WrittenWishCell else {
                return cell
            }

            wishCell.contentView.isUserInteractionEnabled = false

            wishCell.configure(with: wishArray[indexPath.row]) { [weak self] in
                guard let value = self?.remove(index: indexPath.row) else {
                    return
                }
                self?.state.setCustomInEditField(value: value)
                tableView.reloadData()

            } onRemove: { [weak self] in
                self?.remove(index: indexPath.row)
                tableView.reloadData()
            }

            return wishCell
        }
    }
}

extension WishStoringViewController: UITableViewDelegate {
}

private enum Constants {
    static let tableCornerRadius: CGFloat = 20
    static let tableTopOffset: CGFloat = 20
    static let tableBottomOffset: CGFloat = -20
    static let numberOfSections: Int = 2
    static let firstSectionRows: Int = 1

    static let wishesKey: String = "wishes-key"
}

//
//  WishStoringViewController.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit
import Combine
import CoreData

final class WishStoringViewController: UIViewController {

    // MARK: - Properties
    private let table: UITableView = UITableView(frame: .zero)
    private let state: MainState = MainState()
    private let coreDataStack = CoreDataStack.shared
    private var wishArray: [Wish] = []


    // MARK: - Functions

    override func viewDidLoad() {
        view.backgroundColor = .blue
        configureTable()
        fetchWishes()
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

    private func fetchWishes() {
        let fetchRequest: NSFetchRequest<Wish> = Wish.fetchRequest()

        do {
            wishArray = try coreDataStack.viewContext.fetch(fetchRequest)
            table.reloadData()
        } catch {
            print("Failed to fetch wishes: \(error)")
        }
    }

    private func add(value: String) {
        let context = coreDataStack.viewContext
        let newWish = Wish(context: context)
        newWish.content = value

        do {
            try context.save()
            fetchWishes()
        } catch {
            print("Failed to save wish: \(error)")
        }
    }

    @discardableResult
    private func remove(index: Int) -> String {
        guard index < wishArray.count else {
            return ""
        }

        let wishToRemove = wishArray[index]
        let content = wishToRemove.content ?? ""

        coreDataStack.viewContext.delete(wishToRemove)

        do {
            try coreDataStack.viewContext.save()
            fetchWishes()
        } catch {
            print("Failed to delete wish: \(error)")
        }

        return content
    }

    @objc private func shareButtonTapped() {
        let wishTexts = wishArray.compactMap { $0.content }
        let textToShare = "My Wishes:\n" + wishTexts.joined(separator: "\n")

        let activityViewController = UIActivityViewController(
            activityItems: [textToShare],
            applicationActivities: nil
        )

        present(activityViewController, animated: true)
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
                if !(self?.state.edittingValue.isEmpty ?? true) {
                    self?.state.setCustomInEditField(value: "")
                }
                tableView.reloadData()
            } shareAction: { [weak self] in
                self?.shareButtonTapped()
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

            wishCell.configure(with: wishArray[indexPath.row].content ?? "") { [weak self] in
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

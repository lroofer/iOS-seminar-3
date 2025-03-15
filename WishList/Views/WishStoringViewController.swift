//
//  WishStoringViewController.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit

final class WishStoringViewController: UIViewController {

    private let table: UITableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        view.backgroundColor = .blue
        configureTable()
    }

    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .red
        table.dataSource = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius

        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            table.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableTopOffset),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.tableBottomOffset)
        ])
    }
}

extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

private enum Constants {
    static let tableCornerRadius: CGFloat = 20
    static let tableTopOffset: CGFloat = 20
    static let tableBottomOffset: CGFloat = -20
}

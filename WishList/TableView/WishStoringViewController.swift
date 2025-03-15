//
//  WishStoringViewController.swift
//  WishList
//
//  Created by Egor Kolobaev on 06.11.2024.
//

import UIKit

final class WishStoringViewController: UIViewController {

  private var wishArray: [String] = ["I wish to add cells to the table"]

  private lazy var table: UITableView = {
    let subview = UITableView()
    view.addSubview(subview)
    table.backgroundColor = .red
    table.dataSource = self
    table.separatorStyle = .none
    table.layer.cornerRadius = .cornerRadius

    NSLayoutConstraint.activate([
      table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      table.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      table.topAnchor.constraint(equalTo: view.topAnchor)
    ])
    return subview
  }()

  override func viewDidLoad() {
    view.backgroundColor = .blue
  }
}

extension WishStoringViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    wishArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  

}

extension CGFloat {
  static let cornerRadius: Self = 20
}

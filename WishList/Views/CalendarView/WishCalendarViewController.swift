//
//  WishCalendarViewController.swift
//  WishList
//
//  Created by Egor Kolobaev on 16.03.2025.
//

import UIKit
import CoreData

final class WishCalendarViewController: UIViewController {
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let coreDataStack = CoreDataStack.shared
    private var wishEvents: [WishEventModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchWishes()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .add,
            style: .plain,
            target: self,
            action: #selector(addNewEvent)
        )
    }

    private func addEvent(_ event: WishEventDataModel) {
        let context = coreDataStack.viewContext
        let newEvent = WishEventModel(context: context)

        event.fill(newEvent)

        do {
            try context.save()
            fetchWishes()
        } catch {
            print("Failed to save wish: \(error)")
        }
    }

    @objc
    private func addNewEvent() {
        let vc = UINavigationController(
            rootViewController: CreateWishEventViewController(addEvent: addEvent)
        )
        present(vc, animated: true)
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureCollectionView()
    }

    private func fetchWishes() {
        let fetchRequest: NSFetchRequest<WishEventModel> = WishEventModel.fetchRequest()

        do {
            wishEvents = try coreDataStack.viewContext.fetch(fetchRequest)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch wishes: \(error)")
        }
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero

            layout.invalidateLayout()
        }

        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionTop),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 10, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell tapped ad index(\(indexPath.item))")
    }
}

extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        wishEvents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath)

        guard let wishEventCell = cell as? WishEventCell else {
            return cell
        }

        wishEventCell.configure(with: wishEvents[indexPath.row])

        return cell
    }
}

private enum Constants {
    static let contentInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    static let collectionTop: CGFloat = 15
    static let cellHeight: CGFloat = 200
}

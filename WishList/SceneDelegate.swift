//
//  SceneDelegate.swift
//  WishList
//
//  Created by Egor Kolobaev on 15.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        let navC = UINavigationController(rootViewController: WishMakerViewController())
        window.rootViewController = navC
        self.window = window
        window.makeKeyAndVisible()
    }
}


//
//  AppCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    override func start() {
        showSplashView()
    }

    private func showSplashView() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator.delegate = self
        addChild(splashCoordinator)
        splashCoordinator.start()
    }
    
    private func showHomeView() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        addChild(homeCoordinator)
        homeCoordinator.start()
    }
}

extension AppCoordinator: SplashCoordinatorDelegate {
    func goHome() {
        showHomeView()
    }
}

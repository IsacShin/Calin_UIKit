//
//  SplashCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

protocol SplashCoordinatorDelegate: AnyObject {
    func goHome()
}

final class SplashCoordinator: BaseCoordinator {
    
    weak var delegate: SplashCoordinatorDelegate?

    override func start() {
        let splashViewController = SplashViewController()
        splashViewController.configure(vm: SplashViewModel())
        splashViewController.coordinator = self
        
        print("✅ splashVC:", Unmanaged.passUnretained(splashViewController).toOpaque())
        print("✅ coordinator set:", splashViewController.coordinator != nil)
        
        navigationController.viewControllers = [splashViewController]
    }
    
    func goHome() {
        delegate?.goHome()
    }
}

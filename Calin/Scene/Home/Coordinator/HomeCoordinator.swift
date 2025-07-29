//
//  HomeCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

final class HomeCoordinator: BaseCoordinator {
    override func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        homeViewController.configure(viewModel: HomeViewModel())
        navigationController.viewControllers = [homeViewController]
    }
    
    func showAddView() {
        let addCoordinator = AddCoordinator(navigationController: self.navigationController)
        addChild(addCoordinator)
        addCoordinator.start()
    }
    
    func goDetail(for todoDay: TodoDay) {
        let detailCoordinator = DetailCoordinator(navigationController: self.navigationController,
                                                  todoDay: todoDay)
        addChild(detailCoordinator)
        detailCoordinator.start()
    }
}

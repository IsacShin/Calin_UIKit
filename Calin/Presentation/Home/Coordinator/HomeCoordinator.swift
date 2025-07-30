//
//  HomeCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

final class HomeCoordinator: BaseCoordinator {
    
    private let useCase: TodoUseCase
    
    init(navigationController: UINavigationController, useCase: TodoUseCase) {
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        homeViewController.configure(viewModel: HomeViewModel(useCase: useCase))
        navigationController.viewControllers = [homeViewController]
    }
    
    func showAddView() {
        let addCoordinator = AddCoordinator(navigationController: self.navigationController,
                                            useCase: useCase)
        addChild(addCoordinator)
        addCoordinator.start()
    }
    
    func goDetail(for todoDay: TodoDay) {
        let detailCoordinator = DetailCoordinator(navigationController: self.navigationController,
                                                  todoDay: todoDay,
                                                  useCase: useCase)
        addChild(detailCoordinator)
        detailCoordinator.start()
    }
}

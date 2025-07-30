//
//  DetailCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/28/25.
//

import UIKit

final class DetailCoordinator: BaseCoordinator {
    
    private let todoDay: TodoDay
    private let useCase: TodoUseCase
    
    init(navigationController: UINavigationController,
         todoDay: TodoDay,
         useCase: TodoUseCase) {
        self.todoDay = todoDay
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let detailViewController = DetailViewController()
        detailViewController.coordinator = self
        detailViewController.configure(vm: TodoItemCellViewModel(useCase: useCase,
                                                                 todoDay: todoDay))
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func goEditView(for todoDay: TodoDay?) {
        let addCoordinator = AddCoordinator(navigationController: self.navigationController,
                                            useCase: useCase)
        addChild(addCoordinator)
        addCoordinator.showEditView(for: todoDay)
    }
}

//
//  DetailCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/28/25.
//

import UIKit

final class DetailCoordinator: BaseCoordinator {
    private let todoDay: TodoDay
    
    init(navigationController: UINavigationController, todoDay: TodoDay) {
        self.todoDay = todoDay
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let detailViewController = DetailViewController()
        detailViewController.coordinator = self
        detailViewController.configure(vm: TodoItemCellViewModel(todoDay: todoDay))
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func goEditView(for todoDay: TodoDay?) {
        let addCoordinator = AddCoordinator(navigationController: self.navigationController)
        addChild(addCoordinator)
        addCoordinator.showEditView(for: todoDay)
    }
}

//
//  AddCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/24/25.
//

import UIKit

final class AddCoordinator: BaseCoordinator {
    override func start() {
        let addViewController = AddViewController()
        addViewController.coordinator = self
        addViewController.configure(vm: AddViewModel())
        navigationController.pushViewController(addViewController, animated: true)
    }
    
    func showEditView(for todoDay: TodoDay?) {
        let addViewController = AddViewController()
        addViewController.coordinator = self
        addViewController.configure(vm: AddViewModel(todoDay: todoDay))
        navigationController.pushViewController(addViewController, animated: true)
    }
}

extension AddCoordinator {
    func didPopAddView() {
        navigationController.popViewController(animated: true)
    }
    
    func didRootPopAddView() {
        navigationController.popToRootViewController(animated: true)
    }
}

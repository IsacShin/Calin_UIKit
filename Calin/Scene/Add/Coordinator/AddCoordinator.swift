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
}

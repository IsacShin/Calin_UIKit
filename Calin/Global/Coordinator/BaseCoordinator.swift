//
//  BaseCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/23/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func finish()
    func childDidFinish(_ child: Coordinator?)
}

class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parent: BaseCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        // 자식이 부모를 참조할 수 있도록 약한 참조 연결
        (coordinator as? BaseCoordinator)?.parent = self
    }
    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func finish() {
        parent?.childDidFinish(self)
    }
    
}

extension BaseCoordinator {
    func startDatePickerViewFlow(presenter: UIViewController?,
                                 initialDate: Date,
                                 onDatePicked: ((Date) -> Void)? = nil) {
        let datePickerViewCoordinator = DatePickerCoordinator(navigationController: self.navigationController,
                                                              presenter: presenter,
                                                              initialDate: initialDate,
                                                              onDatePicked: onDatePicked)
        addChild(datePickerViewCoordinator)
        datePickerViewCoordinator.start()
    }
}

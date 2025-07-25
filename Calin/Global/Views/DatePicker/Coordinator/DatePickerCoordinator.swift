//
//  DatePickerCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/25/25.
//

import UIKit

final class DatePickerCoordinator: BaseCoordinator {
    private weak var presenter: UIViewController?
    private let initialDate: Date
    private var onDatePicked: ((Date) -> Void)?

    init(navigationController: UINavigationController,
        presenter: UIViewController? = nil,
        initialDate: Date,
        onDatePicked: ((Date) -> Void)? = nil) {
        self.presenter = presenter
        self.initialDate = initialDate
        self.onDatePicked = onDatePicked
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let datePickerViewController = DatePickerViewController()
        datePickerViewController.coordinator = self
        datePickerViewController.delegate = self
        datePickerViewController.configure(vm: DatePickerViewModel(date: self.initialDate))
        datePickerViewController.modalPresentationStyle = .overFullScreen
        presenter?.present(datePickerViewController, animated: true, completion: nil)
    }
}

extension DatePickerCoordinator: DatePickerViewControllerDelegate {
    func datePickerViewController(didSelect date: Date) {
        onDatePicked?(date)
    }
}

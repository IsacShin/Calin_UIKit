//
//  DatePickerViewController.swift
//  Calin
//
//  Created by shinisac on 7/25/25.
//

import UIKit
import Combine

protocol DatePickerViewControllerDelegate: AnyObject {
    func datePickerViewController(didSelect date: Date)
}

final class DatePickerViewModel {
    private(set) var selectedDateSubject = PassthroughSubject<Date, Never>()
    
    init(date: Date) {
        updateSelectDate(date: date)
    }
    
    func updateSelectDate(date: Date) {
        selectedDateSubject.send(date)
    }
}

final class DatePickerViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var coordinator: DatePickerCoordinator?
    weak var delegate: DatePickerViewControllerDelegate?
    var viewModel: DatePickerViewModel?
   
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    convenience init() {
        self.init(nibName: DatePickerViewController.nibName, bundle: nil)
    }
    
    deinit {
        coordinator?.finish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupDatePicker()
        Task { [weak self] in
            try await Task.sleep(for: .seconds(0.18))
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.backgroundView.alpha = 0.3
            }
        }
    }
    
    // MARK: - Methods
    
    func configure(vm: DatePickerViewModel?) {
        self.viewModel = vm
    }
    
    private func setupDatePicker() {
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupBinding() {
        viewModel?.selectedDateSubject
            .sink { [weak self] date in
                guard let self = self else { return }
                self.delegate?.datePickerViewController(didSelect: date)
            }
            .store(in: &cancellables)
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel?.updateSelectDate(date: sender.date)
    }
    
    // MARK: - Actions
    
    @IBAction func actionCompleteButtonPressed(_ sender: Any) {
        delegate?.datePickerViewController(didSelect: datePicker.date)
        Task { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.backgroundView.alpha = 0
            }
            try await Task.sleep(for: .seconds(0.18))
            self?.dismiss(animated: true)
        }
    }
}

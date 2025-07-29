//
//  AddViewController.swift
//  Calin
//
//  Created by shinisac on 7/23/25.
//

import UIKit
import Combine

final class AddViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var addLabels: [UILabel]!
    @IBOutlet var addButonViews: [UIView]!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var deleteButtonView: UIView!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var todoListTableView: UITableView!
    
    weak var coordinator: AddCoordinator?
    var viewModel: AddViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    convenience init() {
        self.init(nibName: AddViewController.nibName, bundle: nil)
    }
    
    deinit {
        coordinator?.finish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupBinding()
    }
    
    // MARK: - Methods
    
    func configure(vm: AddViewModel?) {
        self.viewModel = vm
    }
    
    private func setupTableView() {
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.separatorStyle = .singleLine
        todoListTableView.registerNib(cellType: TodoAddItemCell.self)
    }
    
    private func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))

        toolbar.items = [flexibleSpace, doneButton]
        inputTextField.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        inputTextField.resignFirstResponder()  // 키보드 내리기
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        addLabels.forEach { label in
            label.font = .nanumDaHaeng(size: 20)
        }
        inputTextField.font = .nanumDaHaeng(size: 20)
        addDoneButtonOnKeyboard()
    }

    private func setupBinding() {
        viewModel?.isEditing
            .receive(on: DispatchQueue.main)
            .sink { isEditing in
                self.addButtonView.isHidden = isEditing
                self.editButtonView.isHidden = !isEditing
                self.deleteButtonView.isHidden = !isEditing
            }
            .store(in: &cancellables)
        
        viewModel?.$selectedDate
            .receive(on: DispatchQueue.main)
            .map {
                $0.toYearMonthDayString()
            }
            .assign(to: \.text, on: self.dateLabel)
            .store(in: &cancellables)
        
        viewModel?.$todoList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todoList in
                guard let self = self else { return }
                self.todoListTableView.reloadData()
                self.inputTextField.text = nil
            }
            .store(in: &cancellables)
        
        viewModel?.alertEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alertInfo in
                let alert = UIAlertController(title: nil, message: alertInfo.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    switch alertInfo.actionType {
                    case .updated:
                        self?.coordinator?.didPopAddView()
                    case .deleted, .created:
                        self?.coordinator?.didRootPopAddView()
                    }
                }
                alert.addAction(action)
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Actions
    
    @IBAction func actionCalindarButtonPressed(_ sender: Any) {
        coordinator?.showDataPickerView(presenter: self,
                                        initialDate: viewModel?.selectedDate ?? Date()) { [weak self] date in
            guard let self = self else { return }
            self.viewModel?.updateSelectedDate(date)
        }
    }
    
    @IBAction func actionAddButtonPressed(_ sender: Any) {
        Task {
            await viewModel?.insertTodo()
        }
    }
    
    @IBAction func actionEditButtonPressed(_ sender: Any) {
        Task {
            await viewModel?.updateTodo()
        }
    }
    
    @IBAction func actionDeleteButtonPressed(_ sender: Any) {
        Task {
            await viewModel?.deleteTodo()
        }
    }
    
    @IBAction func actionAddTodoButtonPressed(_ sender: Any) {
        guard let todoText = self.inputTextField.text else { return }
        Task {
            await viewModel?.addTodo(todo: todoText)
        }
    }
}

// MARK: - UITableView Delegate and DataSource

extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.todoList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoAddItemCell = tableView.dequeue(cellType: TodoAddItemCell.self, for: indexPath)
        let title = viewModel?.todoList[indexPath.row].title ?? ""
        cell.delegate = self
        cell.configure(index: indexPath.row, title: title)
        return cell
    }
}

// MARK: - UITableView Cell Delegate

extension AddViewController: TodoAddItemCellDelegate {
    func didDeleteTodo(at index: Int) {
        Task {
            await viewModel?.removeTodo(at: index)
        }
    }
}

//
//  DetailViewController.swift
//  Calin
//
//  Created by shinisac on 7/28/25.
//

import UIKit
import SwiftUI
import Combine

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var fontLabels: [UILabel]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todoCheckTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var coordinator: DetailCoordinator?
    var viewModel: TodoItemCellViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    convenience init() {
        self.init(nibName: DetailViewController.nibName, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }

    
    // MARK: - Methods
    
    private func setupUI() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        setupBackground()
        setupTableView()
        fontLabels.forEach {
            $0.font = .nanumDaHaeng(size: 24)
        }
        titleLabel.textColor = UIColor.black
    }
    
    private func setupBinding() {
        viewModel?.$todoDay
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todoDay in
                self?.titleLabel.text = todoDay?.date.toMonthDayString()
                self?.todoCheckTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        todoCheckTableView.delegate = self
        todoCheckTableView.dataSource = self
        todoCheckTableView.separatorStyle = .singleLine
        todoCheckTableView.registerNib(cellType: TodoCheckItemCell.self)
    }
    
    private func setupBackground() {
        let hostingController = UIHostingController(rootView: FoldedCornerV())
        let foldingView = hostingController.view!
        foldingView.translatesAutoresizingMaskIntoConstraints = false
        foldingView.backgroundColor = .clear

        backgroundView.insertSubview(foldingView, at: 0)

        NSLayoutConstraint.activate([
            foldingView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            foldingView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            foldingView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            foldingView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
    }
        
    func configure(vm: TodoItemCellViewModel?) {
        self.viewModel = vm
    }
    
    // MARK: - Actions
    
    @IBAction func actionEditButtonPressed(_ sender: Any) {
        coordinator?.goEditView(for: viewModel?.todoDay)
    }
}

// MARK: - TableView DataSource and Delegate

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.todoDay?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoCheckItemCell = tableView.dequeue(cellType: TodoCheckItemCell.self, for: indexPath)
        if let item = viewModel?.todoDay?.items[indexPath.row] {
            cell.configure(with: item.title,
                           date: viewModel?.todoDay?.date ?? Date(),
                           isCompleted: item.isCompleted,
                           isEditMode: viewModel?.isEditMode ?? false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        viewModel?.toggleItem(at: index)
    }
}

//
//  TodoItemCell.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit
import SwiftUI
import Combine

protocol TodoItemCellDelegate: NSObject {
    func didSelectTodoItem(id: UUID?)
}

final class TodoItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todoCheckTableView: UITableView!
    
    var viewModel: TodoItemCellViewModel?
    weak var delegate: TodoItemCellDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        titleLabel.text = nil
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        setupBackground()
        setupTableView()
        titleLabel.font = .nanumDaHaeng(size: 16)
        titleLabel.textColor = UIColor.black
    }
    
    private func setupTableView() {
        todoCheckTableView.delegate = self
        todoCheckTableView.dataSource = self
        todoCheckTableView.separatorStyle = .singleLine
        todoCheckTableView.registerNib(cellType: TodoCheckItemCell.self)
    }
    
    private func setupBackground() {
        let hostingController = UIHostingController(rootView: FoldedCornerV())
        let backgroundView = hostingController.view!
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .clear

        contentView.insertSubview(backgroundView, at: 0)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel?.$todoDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todoDay in
                self?.titleLabel.text = todoDay?.date.toMonthDayString()
                self?.todoCheckTableView.reloadData()
            }
            .store(in: &cancellables)
    }
      
    func configure(vm: TodoItemCellViewModel?) {
        viewModel = vm
        setupBinding()
    }
}

// MARK: - TableView DataSource and Delegate

extension TodoItemCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.todoDay?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoCheckItemCell = tableView.dequeue(cellType: TodoCheckItemCell.self, for: indexPath)
        if let item = viewModel?.todoDay?.items[indexPath.row] {
            cell.configure(with: item.title, date: viewModel?.todoDay?.date ?? Date(), isCompleted: item.isCompleted)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel?.todoDay?.id
        delegate?.didSelectTodoItem(id: id)
    }
}

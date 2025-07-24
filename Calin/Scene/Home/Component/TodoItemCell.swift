//
//  TodoItemCell.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit
import SwiftUI
import Combine

final class TodoItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todoCheckTableView: UITableView!
    
    var viewModel: TodoItemCellViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    // MARK: - Methods
    
    private func setBindings() {
        // 중복 바인딩 방지
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        viewModel?.$todoDayItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todoDayItem in
                self?.todoCheckTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setUI() {
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
        
    func configure(vm: TodoItemCellViewModel?) {
        self.viewModel = vm
        setBindings()
    }
}

// MARK: - TableView DataSource and Delegate

extension TodoItemCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.todoDayItem?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoCheckItemCell = tableView.dequeue(cellType: TodoCheckItemCell.self, for: indexPath)
        if let item = viewModel?.todoDayItem?.items[indexPath.row] {
            cell.configure(with: item.title, date: item.createdAt, isCompleted: item.isCompleted)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        viewModel?.toggleItem(at: index)
    }
}

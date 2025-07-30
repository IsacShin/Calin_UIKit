//
//  TodoAddItemCell.swift
//  Calin
//
//  Created by shinisac on 7/25/25.
//

import UIKit

protocol TodoAddItemCellDelegate: AnyObject {
    func didDeleteTodo(at index: Int)
}

final class TodoAddItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var index: Int?
    weak var delegate: TodoAddItemCellDelegate?
    
    override func awakeFromNib() {
        setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        titleLabel.font = .nanumDaHaeng(size: 18)
    }
    
    func configure(index: Int, title: String) {
        self.index = index
        self.titleLabel.text = title
    }
    
    @IBAction func actionDeleteTodoButtonPressed(_ sender: Any) {
        guard let index = index else { return }
        delegate?.didDeleteTodo(at: index)
    }
}

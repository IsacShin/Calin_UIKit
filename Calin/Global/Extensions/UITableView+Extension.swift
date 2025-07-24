//
//  UITableView+Ext.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

extension UITableView {
    func registerNib<Cell: UITableViewCell>(cellType: Cell.Type) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: className)
    }
    
    func dequeue<Cell: UITableViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("❌ Couldn't dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}

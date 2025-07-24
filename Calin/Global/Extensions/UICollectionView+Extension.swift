//
//  UICollectionView+Ext.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

extension UICollectionView {
    func registerNib<Cell: UICollectionViewCell>(cellType: Cell.Type) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeue<Cell: UICollectionViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("❌ Couldn't dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}

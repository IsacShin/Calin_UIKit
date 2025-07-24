//
//  TodoCheckItemCell.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

final class TodoCheckItemCell: UITableViewCell {
    
    // MARK: - Properties
        
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    // MARK: - Methods

    private func setUI() {
        lineView.isHidden = true
        titleLabel.font = UIFont.nanumDaHaeng(size: 16)
    }
    
    
    func configure(with title: String,
                   date: Date,
                   isCompleted: Bool) {
        titleLabel.text = title
        checkImageView.image = isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        if date.removeTimeStamp() < Date().removeTimeStamp() && !isCompleted {
            lineView.isHidden = false
        } else {
            lineView.isHidden = true
        }
    }
}

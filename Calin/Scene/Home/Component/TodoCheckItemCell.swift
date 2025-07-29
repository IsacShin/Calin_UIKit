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
        setupUI()
    }
    
    override func prepareForReuse() {
        lineView.isHidden = true
        titleLabel.text = nil
    }
    
    // MARK: - Methods

    private func setupUI() {
        selectionStyle = .none
        titleLabel.font = UIFont.nanumDaHaeng(size: 16)
    }
    
    func configure(with title: String,
                   date: Date,
                   isCompleted: Bool,
                   isEditMode: Bool = false) {
        titleLabel.text = title
        titleLabel.font = isEditMode ? UIFont.nanumDaHaeng(size: 20) : UIFont.nanumDaHaeng(size: 16)
        titleLabel.numberOfLines = isEditMode ? 0 : 2
        checkImageView.image = isCompleted ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        if (date.removeTimeStamp() < Date().removeTimeStamp()) && isCompleted == false {
            lineView.isHidden = false
        } else {
            lineView.isHidden = true
        }
    }
}

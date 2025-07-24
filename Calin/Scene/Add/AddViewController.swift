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
    
    @IBOutlet weak var inputTextField: UITextField!
    
    weak var coordinator: AddCoordinator?
    var viewModel: AddViewModel?
    
    // MARK: - Life Cycle
    
    convenience init() {
        self.init(nibName: AddViewController.nibName, bundle: nil)
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    // MARK: - Methods
    
    func configure(vm: AddViewModel?) {
        self.viewModel = vm
    }
    
    private func setupUI() {
        
    }

    private func setupBinding() {
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func actionAddButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func actionEditButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func actionDeleteButtonPressed(_ sender: Any) {
        
    }
    
}

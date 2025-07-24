//
//  HomeViewController.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var homeLabels: [UILabel]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinator: HomeCoordinator?
    var viewModel: HomeViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    convenience init() {
        self.init(nibName: HomeViewController.nibName, bundle: nil)
    }
    
    deinit {
        coordinator?.finish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setCollectionView()
        setupDatePickerView()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    // MARK: - Methods
    
    func configure(viewModel: HomeViewModel?) {
        self.viewModel = viewModel
    }
    
    private func setupBinding() {
        viewModel?.$todoData
            .receive(on: DispatchQueue.main)
            .sink { todoDay in
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        homeLabels.forEach { label in
            if label.text == "오늘" {
                label.font = .nanumDaHaeng(size: 18)
                label.textColor = UIColor.black
            } else {
                label.font = .nanumDaHaeng(size: 24)
                label.textColor = UIColor.black
            }
        }
    }
    
    private func setupDatePickerView() {
        
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.registerNib(cellType: TodoItemCell.self)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionCalindarButtonPressed(_ sender: Any) {
        print("캘린더 버튼 클릭")
        datePickerView.show(in: self.view)
    }
    
    @IBAction func actionGridButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func actionTodayButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func actionAddButtonPressed(_ sender: Any) {
        coordinator?.showAddView()
    }
    
}

// MARK: - CollectionView DataSource and Delegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.todoData.count ?? 0 // 예시로 10개의 아이템을 표시
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TodoItemCell = collectionView.dequeue(cellType: TodoItemCell.self, for: indexPath)
        cell.configure(vm: TodoItemCellViewModel(todoDayItem: viewModel?.todoData[safe: indexPath.item]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 8
        let spacing: CGFloat = 10
        let totalSpacing = inset * 2 + spacing // 좌우 인셋 + 셀 사이 간격
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 200)
    }
}

#Preview {
    let homeViewController: HomeViewController = HomeViewController.getViewController(fromStoryboard: "Home")
    let viewModel = HomeViewModel()
    homeViewController.configure(viewModel: viewModel)
    return homeViewController
}

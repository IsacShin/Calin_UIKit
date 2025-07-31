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
    @IBOutlet weak var emptyCommentLabel: UILabel!
    @IBOutlet weak var listTypeImageView: UIImageView!
    
    weak var coordinator: HomeCoordinator?
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
            .sink { [weak self] todoDay in
                guard let self = self else { return }
                self.emptyCommentLabel.isHidden = todoDay.count > 0 ? true : false
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.$isGridMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isGridMode in
                guard let self = self else { return }
                UIView.transition(with: self.collectionView,
                                  duration: 0.35,
                                  options: [.transitionCrossDissolve],
                                  animations: {
                                        self.collectionView.reloadSections(IndexSet(integer: 0))
                    self.listTypeImageView.image = isGridMode ? UIImage(systemName: "rectangle.grid.2x2.fill")?
                        .withTintColor(.white, renderingMode: .alwaysOriginal) :
                    UIImage(systemName: "rectangle.grid.1x2.fill")?
                        .withTintColor(.white, renderingMode: .alwaysOriginal)
                                  })
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
        coordinator?.showDataPickerView(presenter: self,
                                        initialDate: viewModel?.selectedDate ?? Date()) { [weak self] date in
            guard let self = self else { return }
            self.viewModel?.updateSelectedDate(date)
        }
    }
    
    @IBAction func actionGridButtonPressed(_ sender: Any) {
        viewModel?.actionGridButtonPressed()
    }
    
    @IBAction func actionTodayButtonPressed(_ sender: Any) {
        viewModel?.actionTodayButtonPressed()
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
        cell.delegate = self
        cell.configure(vm: viewModel?.cellViewModel(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 8
        let spacing: CGFloat = 10
        let totalSpacing = inset * 2 + spacing // 좌우 인셋 + 셀 사이 간격
        let width = viewModel?.isGridMode ?? true ? (collectionView.bounds.width - totalSpacing) / 2 : (collectionView.bounds.width - totalSpacing)
        return CGSize(width: width, height: Define.Device.screenHeight / (viewModel?.isGridMode ?? true ? 2.8 : 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let todoDay = viewModel?.todoData[safe: indexPath.item] else { return }
        coordinator?.goDetail(for: todoDay)
    }
}

extension HomeViewController: TodoItemCellDelegate {
    func didSelectTodoItem(id: UUID?) {
        guard let id = id,
        let todoDay = viewModel?.todoData.filter({ $0.id == id }).first else { return }
        coordinator?.goDetail(for: todoDay)
    }
}

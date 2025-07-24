//
//  ViewController.swift
//  Calin
//
//  Created by shinisac on 7/21/25.
//

import UIKit
import Combine

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var logoImageView: UIImageView!
    weak var coordinator: SplashCoordinator?
    var viewModel: SplashViewModel?
    var onAnimationFinished: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    convenience init() {
        self.init(nibName: SplashViewController.nibName, bundle: nil)
    }

    deinit {
        print("🔥 SplashCoordinator deinit")
        coordinator?.finish()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        print("👀 self in SplashVC:", Unmanaged.passUnretained(self).toOpaque())
        print("👀 coordinator:", coordinator == nil ? "❌ nil" : "✅ set")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewDidAppear()
    }
    
    // MARK: - Methods
    
    func configure(vm: SplashViewModel?) {
        viewModel = vm
    }
    
    private func setupBinding() {
        viewModel?.isScaled
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isScaled in
                guard let self = self else { return }
                let scale: CGFloat = isScaled ? 1.2 : 1.0
                UIView.animate(withDuration: 0.35) {
                    self.logoImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            })
            .store(in: &cancellables)
        
        viewModel?.animationFinished
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFinished in
                guard let self = self else { return }
                if isFinished {
                    coordinator?.goHome()
                }
                
            })
            .store(in: &cancellables)
    }


}


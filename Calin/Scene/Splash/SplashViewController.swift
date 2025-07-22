//
//  ViewController.swift
//  Calin
//
//  Created by shinisac on 7/21/25.
//

import UIKit
import Combine

final class SplashViewModel {
    private(set) var isScaled = PassthroughSubject<Bool, Never>()
    private(set) var animationFinished: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    func viewDidAppear() {
        Task {
            try await Task.sleep(for: .seconds(0.75))
            self.isScaled.send(true)
            
            try await Task.sleep(for: .seconds(0.75))
            self.animationFinished.send(true)
        }
    }
}

final class SplashViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!

    var viewModel: SplashViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    func configure(vm: SplashViewModel) {
        viewModel = vm
    }
    
    private func setBindings() {
        viewModel.isScaled
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isScaled in
                guard let self = self else { return }
                let scale: CGFloat = isScaled ? 1.2 : 1.0
                self.logoImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
            .store(in: &cancellables)
        
        viewModel.animationFinished
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFinished in
                guard let self = self else { return }
                if isFinished {
                    // 코디네이터를 이용한 화면이동
                }
                
            })
            .store(in: &cancellables)
    }


}


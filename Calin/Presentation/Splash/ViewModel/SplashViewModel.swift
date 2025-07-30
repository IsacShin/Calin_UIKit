//
//  SplashViewModel.swift
//  Calin
//
//  Created by shinisac on 7/24/25.
//

import Foundation
import Combine

final class SplashViewModel {
    private(set) var isScaled = PassthroughSubject<Bool, Never>()
    private(set) var animationFinished: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    func viewDidAppear() {
        Task {
            try await Task.sleep(for: .seconds(0.75))
            self.isScaled.send(true)
            
            try await Task.sleep(for: .seconds(1.1))
            self.animationFinished.send(true)
        }
    }
}

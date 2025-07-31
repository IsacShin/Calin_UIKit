//
//  AppCoordinator.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private var useCase: TodoUseCase
    
    init(navigationController: UINavigationController,
         useCase: TodoUseCase) {
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showSplashView()
    }

    private func showSplashView() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator.delegate = self
        addChild(splashCoordinator)
        splashCoordinator.start()
    }
    
    private func showHomeView() {
        Task { @MainActor in
            let repository = SwiftDataTodoDayRepository()
            let useCase = TodoUseCaseImpl(repository: repository)
            let homeCoordinator = HomeCoordinator(navigationController: navigationController,
                                                  useCase: useCase)
            addChild(homeCoordinator)
            homeCoordinator.start()
        }
    }
}

extension AppCoordinator: SplashCoordinatorDelegate {
    func goHome() {
        showHomeView()
    }
    
    /// 딥링크로 들어왔을시 상세 이동 함수
    func openTodoDetail(id: UUID) {
        Task { @MainActor in
            if let todoDay = await useCase.fetchTodo(id: id) {
                let coordinator = DetailCoordinator(navigationController: navigationController,
                                                    todoDay: todoDay,
                                                    useCase: useCase)
                addChild(coordinator)
                coordinator.start()
            } else {
                print("❌ 해당 UUID로 TodoItem을 찾을 수 없음")
            }
        }
    }
}

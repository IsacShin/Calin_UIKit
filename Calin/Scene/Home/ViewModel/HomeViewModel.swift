//
//  HomeViewModel.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Combine
import Foundation

final class HomeViewModel {
    enum ActionEvent {
        case actionGridButtonPressed
        case actionTodayButtonPressed
    }
    @Published private(set) var todoData: [TodoDay] = []
    @Published private(set) var isGridMode: Bool = true

    private(set) var actionEvent: PassthroughSubject<ActionEvent, Never> = .init()
    private(set) var selectedDate: Date = Date()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        actionEvent
            .sink { [weak self ] action in
                switch action {
                case .actionGridButtonPressed:
                    self?.isGridMode.toggle()
                case .actionTodayButtonPressed:
                    self?.updateSelectedDate(Date())
                }
            }
            .store(in: &cancellables)
    }
    
    func viewWillAppear() {
        updateSelectedDate(selectedDate)
    }
    
    func updateSelectedDate(_ date: Date) {
        selectedDate = date
        Task { [weak self] in
            guard let self = self else { return }
            await self.fetchToMonthData(date: selectedDate)
        }
    }
    
    /// 해당월의 일정 데이터 조회 및 이전 미완료 일정 복사 함수
    func fetchToMonthData(date: Date) async {
        self.todoData = []
        let today = Date().removeTimeStamp()
        let originalTodos = await SwiftDataManager.shared.fetchTodoMonth(forMonthOf: date)

        for todo in originalTodos {
            let outdatedItems = todo.items.filter {
                !$0.isCompleted && todo.date < today
            }
            
            if outdatedItems.count > 0 { // 이전날짜에 미완료된 일정이 있으면
                // 오늘 날짜 TodoDay 존재 여부 확인
                if let todayTodo = originalTodos.first(where: { $0.date.removeTimeStamp() == today }) {
                    // 있으면 append
                    await SwiftDataManager.shared.update(id: todayTodo.id) { (day: TodoDay) in
                        let copiedItems = outdatedItems.map { item in
                            TodoItem(
                                id: UUID(),
                                title: item.title,
                                isCompleted: item.isCompleted,
                                createdAt: item.createdAt,
                                referenceId: item.id
                            )
                        }
                        // 미완료 일정 중복제거
                        let existingReferenceIds = Set(originalTodos.flatMap { $0.items }.compactMap { $0.referenceId })
                        let newItems = copiedItems
                            .filter { !existingReferenceIds.contains($0.referenceId ?? UUID()) }
                            .sorted { $0.createdAt < $1.createdAt }

                        day.items.append(contentsOf: newItems)
                    }
                } else {
                    // 없으면 새로 생성
                    let copiedItems = outdatedItems.map { item in
                        TodoItem(
                            id: UUID(),
                            title: item.title,
                            isCompleted: item.isCompleted,
                            createdAt: item.createdAt,
                            referenceId: item.id
                        )
                    }
                    
                    // 미완료 일정 중복제거
                    let existingReferenceIds = Set(originalTodos.flatMap { $0.items }.compactMap { $0.referenceId })
                    let newItems = copiedItems
                        .filter { !existingReferenceIds.contains($0.referenceId ?? UUID()) }
                        .sorted { $0.createdAt < $1.createdAt }

                    let newTodoDay = TodoDay(
                        date: today,
                        deviceId: todo.deviceId,
                        items: newItems
                    )
                    await SwiftDataManager.shared.insert(newTodoDay)
                }
            }
        }
        
        self.todoData = await SwiftDataManager.shared.fetchTodoMonth(forMonthOf: date)
    }
    
}

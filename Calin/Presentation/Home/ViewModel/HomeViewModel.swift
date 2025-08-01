//
//  HomeViewModel.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Combine
import Foundation

final class HomeViewModel {
    @Published private(set) var todoData: [TodoDay] = []
    @Published private(set) var isGridMode: Bool = true

    private(set) var selectedDate: Date = Date()
    
    private let useCase: TodoUseCase
    
    init(useCase: TodoUseCase) {
        self.useCase = useCase
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
        
        await useCase.loadMonthAndCopyUndone(from: date)
        self.todoData = await useCase.fetchTodos(forDay: date)
    }
    
    func cellViewModel(at index: Int) -> TodoItemCellViewModel? {
        guard let todo = todoData[safe: index] else { return nil }
        return TodoItemCellViewModel(useCase: useCase, todoDay: todo)
    }
    
    func actionGridButtonPressed() {
        isGridMode.toggle()
    }
    
    func actionTodayButtonPressed() {
        updateSelectedDate(Date())
    }
}

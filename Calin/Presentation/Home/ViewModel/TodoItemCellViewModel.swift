//
//  TodoItemCellViewModel.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import UIKit
import Combine

final class TodoItemCellViewModel {
    @Published private(set) var todoDay: TodoDay? {
        didSet {
            if let _ = todoDay {
                isEditMode = true
            } else {
                isEditMode = false
            }
        }
    }
    private(set) var isEditMode: Bool = false
    
    private let useCase: TodoUseCase
    
    init(useCase: TodoUseCase,
         todoDay: TodoDay?) {
        self.useCase = useCase
        self.todoDay = todoDay
    }
    
    func viewWillAppear() {
        Task {
            await fetchTodo(id: todoDay?.id)
        }
    }
    
    func toggleItem(at index: Int) {
        guard let todoDay = todoDay, index < todoDay.items.count else {
            return
        }
        let checkId = todoDay.id
        let isCompleted = !todoDay.items[index].isCompleted
        
        // 로컬 데이터 선반영 UI즉시 변경
        var items = todoDay.items
        items[index].isCompleted = isCompleted
        self.todoDay = TodoDay(id: checkId,
                               date: todoDay.date,
                               items: items,
                               deviceId: todoDay.deviceId)
        // 비동기로 DB도 업데이트 (화면과 비동기 분리)
        Task {
            await updateTodoItem(id: checkId,
                                 index: index,
                                 isCompleted: isCompleted)
        }
    }
    
    func updateTodoItem(id: UUID,
                        index: Int,
                        isCompleted: Bool) async {
        
        await useCase.update(id: id) { todoDay in
            guard index < todoDay.items.count else {
                fatalError("Index out of bounds for todo items")
            }
            todoDay.items[index].isCompleted = isCompleted
            return todoDay
        }
    }
    
    func fetchTodo(id: UUID? = nil) async {
        guard let id = id else { return }
        todoDay = await useCase.fetchTodo(id: id)
    }
}

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
    
    init(todoDay: TodoDay?) {
        guard let todoDay = todoDay else {
            return
        }
        self.todoDay = todoDay
    }
    
    func viewWillAppear() {
        Task {
            await fetchTodo(id: todoDay?.id)
        }
    }
    
    func toggleItem(at index: Int) {
        guard var todoDay = todoDay, index < todoDay.items.count else {
            return
        }
        let checkId = todoDay.id
        let isCompleted = !todoDay.items[index].isCompleted
        
        // 로컬 데이터 선반영 UI즉시 변경
        let items = todoDay.items
        items[index].isCompleted = isCompleted
        self.todoDay = TodoDay(id: checkId,
                              date: todoDay.date,
                              deviceId: todoDay.deviceId,
                              items: items)
        // 비동기로 DB도 업데이트 (화면과 비동기 분리)
        Task {
            await updateTodoItem(id: checkId, index: index, isCompleted: isCompleted)
        }
    }
    
    func updateTodoItem(id: UUID,
                        index: Int,
                        isCompleted: Bool) async {
        await SwiftDataManager.shared.update(id: id) { (todoDay: TodoDay) in
            guard index < todoDay.items.count else {
                return
            }
            todoDay.items[index].isCompleted = isCompleted
        }
    }
    
    func fetchTodo(id: UUID? = nil) async {
        guard let id = id else { return }
        let result = await SwiftDataManager.shared.fetch(with: #Predicate<TodoDay> { $0.id == id }).first
        if let todo = result {
            todoDay = todo
        }
    }
}

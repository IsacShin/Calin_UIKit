//
//  TodoUseCase.swift
//  Calin
//
//  Created by shinisac on 7/29/25.
//

import Foundation

protocol TodoUseCase {
    func fetchTodo(id: UUID) async -> TodoDay?
    func fetchTodos(forDay: Date) async -> [TodoDay]
    func insert(todoDay: TodoDay) async -> Bool
    @discardableResult func update(id: UUID, updateBlock: @escaping (inout TodoDay) -> TodoDay) async -> Bool
    func delete(todoDay: TodoDay) async -> Bool
    func loadMonthAndCopyUndone(from date: Date) async
}

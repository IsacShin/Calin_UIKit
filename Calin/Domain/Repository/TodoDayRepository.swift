//
//  TodoDayRepository.swift
//  Calin
//
//  Created by shinisac on 7/29/25.
//

import Foundation

protocol TodoDayRepository {
    @discardableResult func insert(_ todoDay: TodoDay) async -> Bool
    @discardableResult func update(id: UUID, updateBlock: @escaping (inout TodoDay) -> TodoDay) async -> Bool
    @discardableResult func delete(_ todoDay: TodoDay) async -> Bool
    @discardableResult func deleteAll(_ todoDays: [TodoDay]) async -> Bool
    func fetchAll() async -> [TodoDay]
    func fetchTodo(id: UUID) async -> TodoDay?
    func fetchTodoDays(forDay: Date) async -> [TodoDay]
    func fetchTodoMonth(forMonthOf: Date) async -> [TodoDay]
}

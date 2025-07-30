//
//  TodoUseCaseImpl.swift
//  Calin
//
//  Created by shinisac on 7/29/25.
//

import Foundation

final class TodoUseCaseImpl: TodoUseCase {

    private let repository: TodoDayRepository

    init(repository: TodoDayRepository) {
        self.repository = repository
    }

    func fetchTodo(id: UUID) async -> TodoDay? {
        return await repository.fetchTodo(id: id)
    }
    
    func fetchTodos(forDay: Date) async -> [TodoDay] {
        return await repository.fetchTodoDays(forDay: forDay)
    }
    
    @discardableResult
    func insert(todoDay: TodoDay) async -> Bool {
        return await repository.insert(todoDay)
    }
    
    @discardableResult
    func update(id: UUID, updateBlock: @escaping (inout TodoDay) -> TodoDay) async -> Bool {
        return await repository.update(id: id, updateBlock: updateBlock)
    }
    
    @discardableResult
    func delete(todoDay: TodoDay) async -> Bool {
        return await repository.delete(todoDay)
    }
    
    /// 해당월의 일정 데이터 조회 및 이전 미완료 일정 복사 함수
    func loadMonthAndCopyUndone(from date: Date) async {
        let today = Date().removeTimeStamp()
        let originalTodos = await repository.fetchTodoMonth(forMonthOf: date)

        for todo in originalTodos {
            // 지난 날짜에 미완료된 일정 아이템 필터링
            let outdatedItems = todo.items.filter {
                !$0.isCompleted && todo.date < today
            }

            guard !outdatedItems.isEmpty else { continue }

            if let todayTodo = originalTodos.first(where: { $0.date.removeTimeStamp() == today }) {
                // Append to existing TodoDay
                await repository.update(id: todayTodo.id) { day in
                    var updatedDay = day

                    let copiedItems = outdatedItems.map { item in
                        TodoItem(
                            id: UUID(),
                            title: item.title,
                            isCompleted: item.isCompleted,
                            createdAt: item.createdAt,
                            referenceId: item.id
                        )
                    }

                    let existingReferenceIds = Set(originalTodos.flatMap { $0.items }.compactMap { $0.referenceId })
                    let newItems = copiedItems
                        .filter { !existingReferenceIds.contains($0.referenceId ?? UUID()) }
                        .sorted { $0.createdAt < $1.createdAt }

                    updatedDay.items.append(contentsOf: newItems)
                    return updatedDay
                }
            } else {
                // 미완료 일정이 없으면 새로 생성
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
                    id: UUID(),
                    date: today,
                    items: newItems,
                    deviceId: todo.deviceId
                )
                await repository.insert(newTodoDay)
            }
        }
    }
    
}

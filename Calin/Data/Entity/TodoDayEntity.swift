//
//  TodoDayEntity.swift
//  Calin
//
//  Created by shinisac on 7/29/25.
//

import Foundation
import SwiftData

@Model
final class TodoDayEntity: @unchecked Sendable {
    @Attribute(.unique) var id: UUID          // 고유 식별자
    var date: Date                            // 할일 날짜
    @Relationship var items: [TodoItemEntity] // 할일 리스트
    var deviceId: String                      // 디바이스 UUID

    init(id: UUID = UUID(), date: Date, items: [TodoItemEntity], deviceId: String) {
        self.id = id
        self.date = date
        self.items = items
        self.deviceId = deviceId
    }
    
    convenience init(from domain: TodoDay) {
        self.init(id: domain.id,
                  date: domain.date,
                  items: domain.items.map { TodoItemEntity(from: $0) },
                  deviceId: domain.deviceId)
    }
    
    func toDomain() -> TodoDay {
        return TodoDay(id: id, date: date, items: items.map { $0.toDomain() }, deviceId: deviceId)
    }
}

@Model
final class TodoItemEntity {
    @Attribute(.unique) var id: UUID         // 고유 식별자
    var title: String                        // 할일
    var isCompleted: Bool                    // 완료 여부
    var createdAt: Date                      // 생성 날짜
    var referenceId: UUID? = nil             // 참조 ID (기존 미완료 일정 아이템의 ID를 참조)

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date, referenceId: UUID? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.referenceId = referenceId
    }
    
    convenience init(from domain: TodoItem) {
        self.init(id: domain.id,
                  title: domain.title,
                  isCompleted: domain.isCompleted,
                  createdAt: domain.createdAt,
                  referenceId: domain.referenceId)
    }
    
    func toDomain() -> TodoItem {
        return TodoItem(id: id, title: title, isCompleted: isCompleted, createdAt: createdAt, referenceId: referenceId)
    }
}

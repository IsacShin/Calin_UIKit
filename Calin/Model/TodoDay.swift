//
//  TodoDay.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import SwiftData

@Model
class TodoDay: @unchecked Sendable {
    @Attribute(.unique) var id: UUID         // 고유 식별자
    var date: Date                           // 할일 날짜
    var items: [TodoItem] = []               // 할일 리스트
    var deviceId: String                     // 디바이스 UUID

    init(id: UUID = UUID(), date: Date, deviceId: String, items: [TodoItem] = []) {
        self.id = id
        self.date = date
        self.deviceId = deviceId
        self.items = items
    }
}

@Model
class TodoItem {
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
}

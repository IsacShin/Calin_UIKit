//
//  TodoDay.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import SwiftData

struct TodoItem {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var referenceId: UUID?
}

struct TodoDay {
    var id: UUID
    var date: Date
    var items: [TodoItem]
    var deviceId: String
}

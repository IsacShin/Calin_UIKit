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
    @Published private(set) var todoDayItem: TodoDay?
    
    init(todoDayItem: TodoDay?) {
        guard let todoDayItem = todoDayItem else {
            return
        }
        self.todoDayItem = todoDayItem
    }
    
    func toggleItem(at index: Int) {
        guard var todoDayItem = todoDayItem, index < todoDayItem.items.count else {
            return
        }
        let checkId = todoDayItem.items[index].id
        let isCompleted = !todoDayItem.items[index].isCompleted
        
        // 로컬 데이터 선반영 UI즉시 변경
        let items = todoDayItem.items
        items[index].isCompleted = isCompleted
        todoDayItem = TodoDay(id: todoDayItem.id,
                              date: todoDayItem.date,
                              deviceId: todoDayItem.deviceId,
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
            todoDay.items[index].isCompleted = isCompleted
        }
    }
}

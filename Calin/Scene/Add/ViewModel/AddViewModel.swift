//
//  AddViewModel.swift
//  Calin
//
//  Created by shinisac on 7/24/25.
//

import Foundation
import Combine

final class AddViewModel {
    struct AlertInfo {
        enum AlertActionType {
            case created
            case updated
            case deleted
        }
        let message: String
        let actionType: AlertActionType
        let isSuccess: Bool
    }
    
    var todoDay: TodoDay?
    @Published private(set) var selectedDate: Date = Date()
    @Published private(set) var todoList: [TodoItem] = []
    
    let alertEvent = PassthroughSubject<AlertInfo, Never>()
    private(set) var isEditing: CurrentValueSubject<Bool, Never> = .init(false)
    
    init(todoDay: TodoDay? = nil) {
        self.isEditing.send(todoDay != nil)
        self.todoDay = todoDay
        if let todoDay = todoDay {
            self.updateSelectedDate(todoDay.date)
            self.todoList = todoDay.items
        }
    }
    
    func updateSelectedDate(_ date: Date) {
        selectedDate = date
    }
    
    func addTodo(todo: String) async {
        guard !todo.isEmpty else {
            return
        }
        
        let todoItem = TodoItem(title: todo, createdAt: selectedDate)
        todoList.append(todoItem)
    }
    
    func removeTodo(at index: Int) async {
        guard index >= 0 && index < todoList.count else { return }
        todoList.remove(at: index)
    }
    
    func insertTodo() async {
        guard !todoList.isEmpty else {
            alertEvent.send(AlertInfo(message: "할 일을 추가해주세요.",
                                      actionType: .created,
                                      isSuccess: false))
            return
        }
        
        let deviceID = Define.Device.uuid
        let todoDay = TodoDay(date: selectedDate,
            deviceId: deviceID,
            items: todoList.sorted(by: { $0.createdAt > $1.createdAt }))

        await SwiftDataManager.shared.insert(todoDay)
        alertEvent.send(AlertInfo(message: "일정이 추가되었습니다.",
                                  actionType: .created,
                                  isSuccess: true))
    }
    
    func updateTodo() async {
        guard let id = todoDay?.id,
              !todoList.isEmpty else {
            alertEvent.send(AlertInfo(message: "할 일을 추가해주세요.",
                                      actionType: .updated,
                                      isSuccess: false))
            return
        }
        
        await SwiftDataManager.shared.update(id: id) { (todoDay: TodoDay) in
            todoDay.items = todoList.sorted(by: { $0.createdAt > $1.createdAt })
            todoDay.date = selectedDate
        }
        alertEvent.send(AlertInfo(message: "일정이 수정되었습니다.",
                                  actionType: .updated,
                                  isSuccess: true))
    }
    
    func deleteTodo() async {
        guard let todoDay = todoDay else { return }
        await SwiftDataManager.shared.delete(todoDay)
        alertEvent.send(AlertInfo(message: "일정이 삭제되었습니다.",
                                  actionType: .deleted,
                                  isSuccess: true))
    }
    
}

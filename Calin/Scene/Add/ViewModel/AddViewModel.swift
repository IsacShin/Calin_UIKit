//
//  AddViewModel.swift
//  Calin
//
//  Created by shinisac on 7/24/25.
//

import Foundation
import Combine

final class AddViewModel {
    var todoDay: TodoDay?
    @Published private(set) var selectedDate: Date = Date()
    @Published private(set) var todoList: [TodoItem] = []
    
    private(set) var alertMessage: PassthroughSubject<String, Never> = .init()
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
            alertMessage.send("할 일을 추가해주세요.")
            return
        }
        
        let deviceID = Define.Device.uuid
        let todoDay = TodoDay(date: selectedDate,
            deviceId: deviceID,
            items: todoList.sorted(by: { $0.createdAt > $1.createdAt }))

        await SwiftDataManager.shared.insert(todoDay)
        alertMessage.send("일정이 추가되었습니다.")
    }
    
    func updateTodo() async {
        guard let id = todoDay?.id,
              !todoList.isEmpty else {
            alertMessage.send("할 일을 추가해주세요.")
            return
        }
        
        await SwiftDataManager.shared.update(id: id) { (todoDay: TodoDay) in
            todoDay.items = todoList.sorted(by: { $0.createdAt > $1.createdAt })
            todoDay.date = selectedDate
        }
        alertMessage.send("일정이 수정되었습니다.")
    }
    
    func deleteTodo() async {
        guard let todoDay = todoDay else { return }
        await SwiftDataManager.shared.delete(todoDay)
        alertMessage.send("일정이 삭제되었습니다.")
    }
    
}

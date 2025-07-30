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
    private let useCase: TodoUseCase
    
    init(useCase: TodoUseCase,
         todoDay: TodoDay? = nil) {
        self.useCase = useCase
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
        
        let todoItem = TodoItem(id: UUID(),
                                title: todo,
                                isCompleted: false,
                                createdAt: selectedDate)
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
        let todoDay = TodoDay(id: UUID(),
                              date: selectedDate,
                              items: todoList.sorted(by: { $0.createdAt > $1.createdAt }),
                              deviceId: deviceID)
        
        var isSuccess: Bool = false
        var msg: String = ""
        if await useCase.insert(todoDay: todoDay) {
            msg = "일정이 추가되었습니다."
            isSuccess = true
        } else {
            msg = "다시 시도해주세요."
            isSuccess = false
        }
        
        alertEvent.send(AlertInfo(message: msg,
                                  actionType: .created,
                                  isSuccess: isSuccess))
    }
    
    func updateTodo() async {
        guard let id = todoDay?.id,
              !todoList.isEmpty else {
            alertEvent.send(AlertInfo(message: "할 일을 추가해주세요.",
                                      actionType: .updated,
                                      isSuccess: false))
            return
        }
        
        var isSuccess: Bool = false
        var msg: String = ""
        if await useCase.update(id: id, updateBlock: { todoDay in
            todoDay.items = self.todoList.sorted(by: { $0.createdAt > $1.createdAt })
            todoDay.date = self.selectedDate
            return todoDay
        }) {
            msg = "일정이 수정되었습니다."
            isSuccess = true
        } else {
            msg = "다시 시도해주세요."
            isSuccess = false
        }
        alertEvent.send(AlertInfo(message: msg,
                                  actionType: .updated,
                                  isSuccess: isSuccess))
    }
    
    func deleteTodo() async {
        guard let todoDay = todoDay else { return }
        var isSuccess: Bool = false
        var msg: String = ""
        if await useCase.delete(todoDay: todoDay) {
            msg = "일정이 삭제되었습니다."
            isSuccess = true
        } else {
            msg = "다시 시도해주세요."
            isSuccess = false
        }
        
        alertEvent.send(AlertInfo(message: msg,
                                  actionType: .deleted,
                                  isSuccess: isSuccess))
    }
    
}

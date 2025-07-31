//
//  SwiftDataTodoDayRepository.swift
//  Calin
//
//  Created by shinisac on 7/29/25.
//

import Foundation
import SwiftData
import WidgetKit

@MainActor
final class SwiftDataTodoDayRepository: TodoDayRepository {

    private let modelContainer: ModelContainer
    private let context: ModelContext
    
    init() {
        // App Group ID
        let appGroupID = "group.com.isac.calin"
        
        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            fatalError("App Group 경로를 찾을 수 없습니다")
        }
        
        let config = ModelConfiguration(
            "SharedModel",
            url: sharedURL.appendingPathComponent("SharedModel.sqlite")
        )
        
        do {
            self.modelContainer = try ModelContainer(for: TodoDayEntity.self, configurations: config)
            self.context = modelContainer.mainContext
        } catch {
            fatalError("SwiftData 초기화 실패: \(error)")
        }
    }
    
    func fetchTodo(id: UUID) async -> TodoDay? {
        let descriptor = FetchDescriptor<TodoDayEntity>(predicate: #Predicate { $0.id == id })
        do {
            let results = try context.fetch(descriptor)
            return results.first?.toDomain()
        } catch {
            print("Failed to fetch TodoDayEntity with id \(id): \(error)")
            return nil
        }
    }
    
    func fetchTodoMonth(forMonthOf date: Date) async -> [TodoDay] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)

        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return []
        }

        let predicate = #Predicate<TodoDayEntity> {
            $0.date >= startOfMonth && $0.date <= endOfMonth
        }

        let descriptor = FetchDescriptor<TodoDayEntity>(predicate: predicate, sortBy: [SortDescriptor(\.date, order: .reverse)])

        do {
            let entities = try context.fetch(descriptor)
            return entities.map { $0.toDomain() }
        } catch {
            print("Failed to fetch TodoDayEntities for month \(date): \(error)")
            return []
        }
    }
    
    func fetchTodoDays(forDay date: Date) async -> [TodoDay] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }

        let predicate = #Predicate<TodoDayEntity> {
            $0.date >= startOfDay && $0.date < endOfDay
        }

        let descriptor = FetchDescriptor<TodoDayEntity>(predicate: predicate, sortBy: [SortDescriptor(\.date, order: .reverse)])

        do {
            let entities = try context.fetch(descriptor)
            return entities.map { $0.toDomain() }
        } catch {
            print("Failed to fetch TodoDayEntities for day \(date): \(error)")
            return []
        }
    }
    
    func fetchAll() async -> [TodoDay] {
        let descriptor = FetchDescriptor<TodoDayEntity>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        do {
            let entities = try context.fetch(descriptor)
            return entities.map { $0.toDomain() }
        } catch {
            print("Failed to fetch TodoDayEntities \(error)")
            return []
        }
    }
    
    func insert(_ todoDay: TodoDay) async -> Bool {
        // 1. 날짜 기준으로 중복 확인
        let existingDays = await fetchTodoDays(forDay: todoDay.date)
        
        if var existingDay = existingDays.first {
            // 2. 중복 제거 후 append 방식으로 병합
            let existingReferenceIds = Set(existingDay.items.compactMap { $0.referenceId })
            let newItems = todoDay.items.filter { !existingReferenceIds.contains($0.referenceId ?? UUID()) }
            existingDay.items.append(contentsOf: newItems)
            return await save()
        } else {
            // 3. 없으면 새로 생성 및 저장
            let entity = TodoDayEntity(from: todoDay)
            context.insert(entity)
            return await save()
        }
    }
    
    func update(id: UUID, updateBlock: @escaping (inout TodoDay) -> TodoDay) async -> Bool {
        let fetchDescriptor = FetchDescriptor<TodoDayEntity>(predicate: #Predicate { $0.id == id })
        
        guard let originalEntity = try? context.fetch(fetchDescriptor).first else {
            print("Object not found.")
            return false
        }
        
        // 1. 도메인 객체로 변환
        var domain = originalEntity.toDomain()
        
        // 2. 수정 로직 적용
        let updated = updateBlock(&domain)

        // 3. 업데이트 적용
        originalEntity.date = updated.date
        
        // 4. 기존 items 모두 삭제 (SwiftData 관계 정리 포함)
        for item in originalEntity.items {
            context.delete(item)
        }

        // 새로운 items 추가
        originalEntity.items = updated.items.map { TodoItemEntity(from: $0) }

        return await save()
    }
    
    func delete(_ todoDay: TodoDay) async -> Bool {
        let entity = TodoDayEntity(from: todoDay)
        context.delete(entity)
        return await save()
    }
    
    func deleteAll(_ todoDays: [TodoDay]) async -> Bool {
        for todoDay in todoDays {
            let entity = TodoDayEntity(from: todoDay)
            context.delete(entity)
        }
        return await save()
    }
}

extension SwiftDataTodoDayRepository {
    @discardableResult
    func save() async -> Bool {
        do {
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "CalinWidget")
            return true
        } catch {
            print("Failed to save context: \(error)")
            return false
        }
    }
}

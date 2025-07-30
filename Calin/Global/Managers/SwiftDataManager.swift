//
//  SwiftDataManager.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import SwiftData
import WidgetKit

//@MainActor
//class SwiftDataManager {
//    static let shared = SwiftDataManager()
//
//    let modelContainer: ModelContainer
//    let context: ModelContext
//
//    private init() {
//        // App Group ID
//        let appGroupID = "group.com.isac.calin"
//        
//        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
//            fatalError("App Group 경로를 찾을 수 없습니다")
//        }
//        
//        let config = ModelConfiguration(
//            "SharedModel",
//            url: sharedURL.appendingPathComponent("SharedModel.sqlite")
//        )
//        
//        do {
//            self.modelContainer = try ModelContainer(for: TodoDay.self, configurations: config)
//            self.context = modelContainer.mainContext
//        } catch {
//            fatalError("SwiftData 초기화 실패: \(error)")
//        }
//    }
//
//    // MARK: - Create
//
//    func insert<T: PersistentModel>(_ object: T) async {
//        guard let object = object as? TodoDay else {
//            print("Object is not of type TodoDay")
//            return
//        }
//        // 1. 날짜 기준으로 중복 확인
//        let existingDays = await fetchTodoDays(forDay: object.date)
//        
//        if let existingDay = existingDays.first {
//            // 2. 중복 제거 후 append 방식으로 병합
//            let existingReferenceIds = Set(existingDay.items.compactMap { $0.referenceId })
//            let newItems = object.items.filter { !existingReferenceIds.contains($0.referenceId ?? UUID()) }
//            existingDay.items.append(contentsOf: newItems)
//            await save()
//        } else {
//            // 3. 없으면 새로 생성 및 저장
//            context.insert(object)
//            await save()
//        }
//    }
//    
//    func update<T: PersistentModel & Identifiable>(id: UUID, updateBlock: (T) -> Void) async where T.ID == UUID {
//        let results = await fetch(with: #Predicate<T> { $0.id == id })
//        guard let object = results.first else {
//            print("Object not found.")
//            return
//        }
//
//        updateBlock(object)
//        await save()
//    }
//
//    // MARK: - Read
//    
//    func fetchAll<T: PersistentModel>(
//        sortedBy sortDescriptor: SortDescriptor<T>? = nil
//    ) async -> [T] {
//        var descriptor = FetchDescriptor<T>()
//        if let sort = sortDescriptor {
//            descriptor = FetchDescriptor<T>(sortBy: [sort])
//        }
//        do {
//            return try context.fetch(descriptor)
//        } catch {
//            print("Failed to fetch \(T.self): \(error)")
//            return []
//        }
//    }
//
//    func fetch<T: PersistentModel>(with predicate: Predicate<T>) async -> [T] {
//        let descriptor = FetchDescriptor<T>(predicate: predicate)
//        do {
//            return try context.fetch(descriptor)
//        } catch {
//            print("Failed to fetch \(T.self) with predicate: \(error)")
//            return []
//        }
//    }
//    
//    func fetch<T: PersistentModel, V: Comparable>(
//        with predicate: Predicate<T>,
//        sortKeyPath: KeyPath<T, V>,
//        order: SortOrder = .forward
//    ) async -> [T] {
//        let sortDescriptor = SortDescriptor(sortKeyPath, order: order)
//        let descriptor = FetchDescriptor<T>(
//            predicate: predicate,
//            sortBy: [sortDescriptor]
//        )
//
//        do {
//            return try context.fetch(descriptor)
//        } catch {
//            print("Failed to fetch \(T.self) with predicate: \(error)")
//            return []
//        }
//    }
//
//    // MARK: - Update
//
//    func save() async {
//        do {
//            try context.save()
//            WidgetCenter.shared.reloadTimelines(ofKind: "DoinAppWidget")
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//
//    // MARK: - Delete
//
//    func delete<T: PersistentModel>(_ object: T) async {
//        context.delete(object)
//        await save()
//    }
//
//    func deleteAll<T: PersistentModel>(_ objects: [T]) async {
//        for object in objects {
//            context.delete(object)
//        }
//        await save()
//    }
//}
//
//extension SwiftDataManager {
//    
//    /// 일자별 TodoDay 가져오기 (동일한 날짜)
//    func fetchTodoDays(forDay date: Date) async -> [TodoDay] {
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: date)
//        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
//            return []
//        }
//
//        return await fetch(with: #Predicate<TodoDay> {
//            $0.date >= startOfDay && $0.date < endOfDay
//        }, sortKeyPath: \TodoDay.date, order: .reverse)
//    }
//    
//    /// 월별 TodoDay 가져오기 (동일한 연/월)
//    func fetchTodoMonth(forMonthOf date: Date) async -> [TodoDay] {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month], from: date)
//
//        guard let startOfMonth = calendar.date(from: components),
//              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
//            return []
//        }
//
//        return await fetch(with: #Predicate<TodoDay> {
//            $0.date >= startOfMonth && $0.date <= endOfMonth
//        }, sortKeyPath: \TodoDay.date, order: .reverse)
//    }
//    
//    /// 특정 날짜의 TodoDay 업데이트
//    func update(date: Date, updateBlock: (TodoDay) -> Void) async {
//        let results = await fetch(with: #Predicate<TodoDay> { $0.date == date })
//        guard let object = results.first else {
//            print("Object not found.")
//            return
//        }
//
//        updateBlock(object)
//        await save()
//    }
//}

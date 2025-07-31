//
//  CalinWidget.swift
//  CalinWidget
//
//  Created by shinisac on 7/30/25.
//

import WidgetKit
import SwiftUI

@MainActor
struct Provider: @preconcurrency TimelineProvider {
    var useCase: TodoUseCase
    
    init() {
        let repository = SwiftDataTodoDayRepository()
        let useCase = TodoUseCaseImpl(repository: repository)
        self.useCase = useCase
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        Task { @MainActor in
            let todos = await useCase.fetchTodos(forDay: Date()).first
            let entry = SimpleEntry(date: Date(), todos: todos)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        Task { @MainActor in
            let todos = await useCase.fetchTodos(forDay: Date()).first

            let entry = SimpleEntry(date: Date(), todos: todos)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 30))) // 30분마다 새로고침
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todos: TodoDay?
}

struct CalinWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            getWidgetView(for: .systemSmall, showCount: 3)
        case .systemMedium:
            getMediumWidgetView(showCount: 5)
        case .systemLarge:
            getWidgetView(for: .systemLarge, showCount: 12)
        default:
            Text("지원하지 않는 위젯 크기입니다.")
                .font(.nanumDaHaeng(size: 18))
                .foregroundStyle(.accent)
                .padding()
        }
    }
    
    func getMediumWidgetView(showCount: Int = 3) -> some View {
        HStack {
            VStack {
                Text(Date().toYearMonthDayString())
                    .font(.nanumDaHaeng(size: 24))
                    .foregroundStyle(.accent)
                    .bold()
                Text("[\(String(describing: entry.todos?.items.filter { !$0.isCompleted }.count ?? 0))/\(entry.todos?.items.count ?? 0)]")
                    .font(.nanumDaHaeng(size: 24))
            }
            
            Divider()
                .frame(height: 24)
                .background(Color.accentColor)
            
            if let todos = entry.todos {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(
                        Array(todos.items.prefix(showCount).sorted(by: { $0.createdAt > $1.createdAt }).enumerated()),
                        id: \.element.id
                    ) { index, todo in
                        Link(destination: URL(string: "todoapp://todo/\(todos.id)")!) {
                            HStack(spacing: 8) {
                                Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.red)
                                Text(todo.title)
                                    .font(.nanumDaHaeng(size: 18))
                                    .foregroundStyle(.accent)
                                Spacer()
                            }
                        }
                    }
                }

            } else {
                Text("등록된 할 일이 없습니다.")
                    .font(.nanumDaHaeng(size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding(.init(top: 4, leading: 10, bottom: 10, trailing: 10))
        .widgetURL(URL(string: "todoapp://today")) // 눌렀을 때 딥링크
    }
    
    func getWidgetView(for size: WidgetFamily, showCount: Int = 3) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if size == .systemLarge {
                HStack {
                    Text(Date().toYearMonthDayString())
                        .font(.nanumDaHaeng(size: size == .systemSmall ? 20 : 24))
                        .foregroundStyle(.accent)
                        .bold()
                    Text("[\(String(describing: entry.todos?.items.filter { !$0.isCompleted }.count ?? 0))/\(entry.todos?.items.count ?? 0)]")
                        .font(.nanumDaHaeng(size: size == .systemSmall ? 20 : 24))
                    Spacer()
                }
            } else {
                Text(Date().toYearMonthDayString())
                    .font(.nanumDaHaeng(size: size == .systemSmall ? 20 : 24))
                    .foregroundStyle(.accent)
                    .bold()
                Text("[\(String(describing: entry.todos?.items.filter { !$0.isCompleted }.count ?? 0))/\(entry.todos?.items.count ?? 0)]")
                    .font(.nanumDaHaeng(size: size == .systemSmall ? 20 : 24))
            }
                        
            if let todos = entry.todos {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(
                        Array(todos.items.prefix(showCount).sorted(by: { $0.createdAt > $1.createdAt }).enumerated()),
                        id: \.element.id
                    ) { index, todo in
                        Link(destination: URL(string: "todoapp://todo/\(todos.id)")!) {
                            HStack(spacing: 8) {
                                Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: size == .systemSmall ? 12 : 14, height: size == .systemSmall ? 12 : 14)
                                    .foregroundColor(.red)
                                Text(todo.title)
                                    .font(.nanumDaHaeng(size: size == .systemSmall ? 14 : 18))
                                    .foregroundStyle(.accent)
                                Spacer()
                            }
                        }
                    }
                }

            } else {
                Text("등록된 할 일이 없습니다.")
                    .font(.nanumDaHaeng(size: size == .systemSmall ? 14 : 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }

            Spacer()
        }
        .padding(.init(top: 4, leading: 10, bottom: 10, trailing: 10))
        .widgetURL(URL(string: "todoapp://today")) // 눌렀을 때 딥링크
    }
}

struct CalinWidget: Widget {
    let kind: String = "CalinWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CalinWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 250/255, green: 237/255, blue: 125/255), for: .widget)
            } else {
                CalinWidgetEntryView(entry: entry)
                    .padding()
                    .containerBackground(Color(red: 250/255, green: 237/255, blue: 125/255), for: .widget)
            }
        }
        .configurationDisplayName("Calin")
        .description("오늘 등록된 할 일을 간단히 보여줍니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge]) // 원하는 사이즈
    }
}

#Preview(as: .systemSmall) {
    CalinWidget()
} timeline: {
    SimpleEntry(date: .now, todos: nil)
}

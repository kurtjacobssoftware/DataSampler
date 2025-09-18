//  Created by Kurt Jacobs

import Foundation
import SwiftData
import Combine


public class SwiftDataTodoProvider: TodoProvider {

    let storeURL = URL.documentsDirectory.appending(path: "shared.store")
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    public var newChangesPublisher: AnyPublisher<Void, Never> {
        newChangesSubject.eraseToAnyPublisher()
    }

    private var newChangesSubject: CurrentValueSubject<Void, Never> = .init(())

    public init() {
            let modelConfiguration = ModelConfiguration(url: storeURL)
            let modelContainer = try? ModelContainer(for: TodoDTO.self, configurations: modelConfiguration)
            let modelContext = ModelContext(modelContainer!)

            self.modelContainer = modelContainer
            self.modelContext = modelContext
    }

    // MARK: Conformance
    
    public func getAllTodos() throws -> [Todo] {
            let descriptor = FetchDescriptor<TodoDTO>()
            let items: [TodoDTO]? = try modelContext?.fetch(descriptor)
            return items?.map { Todo(dto: $0) } ?? []

    }

    public func save(todo: Todo) throws {
            let todo = TodoDTO(identifier: UUID(), title: todo.title, content: todo.content)
            modelContext?.insert(todo)
            try modelContext?.save()
            newChangesSubject.send(())

    }

    public func delete(todo: Todo) throws {
            guard let searchIdentifier = UUID(uuidString: todo.id) else { throw NSError(domain: "com.todos.kurt", code: 007, userInfo: [:]) }
            try? modelContext?.delete(model: TodoDTO.self, where: #Predicate<TodoDTO>{ $0.identifier == searchIdentifier })
            try? modelContext?.save()
            newChangesSubject.send(())
    }

    public func update(todo: Todo, completed: Bool) throws {
            guard let searchIdentifier = UUID(uuidString: todo.id) else { throw NSError(domain: "com.todos.kurt", code: 007, userInfo: [:]) }
            let descriptor = FetchDescriptor<TodoDTO>(predicate: #Predicate<TodoDTO>{ $0.identifier == searchIdentifier })
            let item = try? modelContext?.fetch(descriptor).first
            item?.isCompleted = completed
            try? modelContext?.save()
            newChangesSubject.send(())
    }
}

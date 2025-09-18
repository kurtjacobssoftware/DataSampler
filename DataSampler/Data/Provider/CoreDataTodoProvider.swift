// Created by Kurt Jacobs

import Foundation
import CoreData
import Combine

public class CoreDataTodoProvider: TodoProvider {
    let storeURL = URL.documentsDirectory.appending(path: "shared.store")
    public var modelContainer: NSPersistentContainer?
    public var modelContext: NSManagedObjectContext?

    public var newChangesPublisher: AnyPublisher<Void, Never> {
        newChangesSubject.eraseToAnyPublisher()
    }

    private var newChangesSubject: CurrentValueSubject<Void, Never> = .init(())

    public init() {

        guard let modelURL = Bundle.main.url(forResource: "Todos", withExtension: "momd") else { return }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return }

        let modelContainer = NSPersistentContainer(name: "Todos", managedObjectModel: model)
        if let description = modelContainer.persistentStoreDescriptions.first {
            description.url = storeURL
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            modelContainer.persistentStoreDescriptions = [description]
        }

        modelContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Could not load persistent stores. \(error!)")
            }
        }

        let modelContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        modelContext.persistentStoreCoordinator = modelContainer.persistentStoreCoordinator

        self.modelContainer = modelContainer
        self.modelContext = modelContext
    }

    // MARK: Conformance
    
    public func getAllTodos() throws -> [Todo] {
        let request: NSFetchRequest<CDTodoDTO> = CDTodoDTO.fetchRequest()
        let result = try self.modelContext?.fetch(request)
        return result?.map { Todo(dto: $0) } ?? []
    }

    public func save(todo: Todo) throws {
        let newTodo = CDTodoDTO(context: self.modelContext!)
        newTodo.identifier = UUID()
        newTodo.title = todo.title
        newTodo.content = todo.content
        try self.modelContext?.save()
        newChangesSubject.send(())
    }

    public func delete(todo: Todo) throws {
        let request: NSFetchRequest<CDTodoDTO> = CDTodoDTO.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CDTodoDTO.identifier), UUID(uuidString: todo.id)! as NSUUID)
        let result = try self.modelContext?.fetch(request)
        let todoToDelete = result?.first

        guard let todoToDelete else { return }

        modelContext?.delete(todoToDelete)
        try modelContext?.save()
        newChangesSubject.send(())
    }

    public func update(todo: Todo, completed: Bool) throws {
        let request: NSFetchRequest<CDTodoDTO> = CDTodoDTO.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CDTodoDTO.identifier), UUID(uuidString: todo.id)! as NSUUID)
        let result = try self.modelContext?.fetch(request)
        let todoToUpdate = result?.first

        todoToUpdate?.isCompleted = completed

        try modelContext?.save()
        newChangesSubject.send(())
    }
}

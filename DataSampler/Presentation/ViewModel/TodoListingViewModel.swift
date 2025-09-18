// Created by Kurt Jacobs

import Foundation
import Combine

public protocol TodoListingViewModelDependencies {
    var coreDataTodoProvider: TodoProvider { get set }
    var swiftDataTodoProvider: TodoProvider { get set }
    var datasourceTypeProvider: DatasourceTypeProvider { get set }
}

@Observable
public class TodoListingViewModel {
    var dependencies: TodoListingViewModelDependencies

    var todos: [Todo] = []
    var cancelBag: Set<AnyCancellable> = []

    public init(dependencies: TodoListingViewModelDependencies) {
        self.dependencies = dependencies
        self.configureBindings()
    }

    func configureBindings() {
        dependencies.coreDataTodoProvider.newChangesPublisher.combineLatest(dependencies.swiftDataTodoProvider.newChangesPublisher)
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                switch self?.dependencies.datasourceTypeProvider.selectedDatasource ?? .swiftData {
                case .swiftData:
                    self?.todos = (try? self?.dependencies.swiftDataTodoProvider.getAllTodos()) ?? []
                case .coreData:
                    self?.todos = (try? self?.dependencies.coreDataTodoProvider.getAllTodos()) ?? []
                }
        }
        .store(in: &cancelBag)
    }

    // MARK: Todos

    func load() {
        switch dependencies.datasourceTypeProvider.selectedDatasource {
        case .swiftData:
            self.todos = (try? dependencies.swiftDataTodoProvider.getAllTodos()) ?? []
        case .coreData:
            self.todos = (try? dependencies.coreDataTodoProvider.getAllTodos()) ?? []
        }
    }

    func delete(todo: Todo) throws {
        switch dependencies.datasourceTypeProvider.selectedDatasource {
        case .swiftData:
            try dependencies.swiftDataTodoProvider.delete(todo: todo)
        case .coreData:
            try dependencies.coreDataTodoProvider.delete(todo: todo)
        }
    }

    func update(todo: Todo, completed: Bool) throws {
        switch dependencies.datasourceTypeProvider.selectedDatasource {
        case .swiftData:
            try dependencies.swiftDataTodoProvider.update(todo: todo, completed: completed)
        case .coreData:
            try dependencies.coreDataTodoProvider.update(todo: todo, completed: completed)
        }
    }

    // MARK: Datasource

    func currentDatasource() -> DatasourceType {
        return dependencies.datasourceTypeProvider.selectedDatasource
    }

    func updateCurrentDatasource(to type: DatasourceType) {
        dependencies.datasourceTypeProvider.selectedDatasource = type
    }
}

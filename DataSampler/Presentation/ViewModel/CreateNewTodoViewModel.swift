// Created by Kurt Jacobs

import SwiftUI

public protocol CreateNewTodoViewModelDependencies {
    var coreDataTodoProvider: TodoProvider { get set }
    var swiftDataTodoProvider: TodoProvider { get set }
    var datasourceTypeProvider: DatasourceTypeProvider { get set }
}

public class CreateNewTodoViewModel {
    var dependencies: CreateNewTodoViewModelDependencies

    public init(dependencies: CreateNewTodoViewModelDependencies) {
        self.dependencies = dependencies
    }

    func save(todo: Todo) throws {
        switch dependencies.datasourceTypeProvider.selectedDatasource {
        case .swiftData:
            try self.dependencies.swiftDataTodoProvider.save(todo: todo)
        case .coreData:
            try self.dependencies.coreDataTodoProvider.save(todo: todo)
        }
    }
}

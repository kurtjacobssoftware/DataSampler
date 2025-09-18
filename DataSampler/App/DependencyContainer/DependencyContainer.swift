// Created by Kurt Jacobs

import SwiftUI
import Combine

class DependencyContainer: ObservableObject, TodoListingViewModelDependencies, CreateNewTodoViewModelDependencies {

    lazy var coreDataTodoProvider: TodoProvider = CoreDataTodoProvider()
    lazy var swiftDataTodoProvider: TodoProvider = SwiftDataTodoProvider()
    lazy var datasourceTypeProvider: DatasourceTypeProvider = UserDefaultsDatasourceTypeProvider()
}

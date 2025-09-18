// Created by Kurt Jacobs

import Foundation
import Combine

public protocol TodoProvider {
    func save(todo: Todo) throws
    func delete(todo: Todo) throws
    func getAllTodos() throws -> [Todo]
    func update(todo: Todo, completed: Bool) throws

    var newChangesPublisher: AnyPublisher<Void, Never> { get }
}

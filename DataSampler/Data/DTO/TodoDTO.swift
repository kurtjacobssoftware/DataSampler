// Created by Kurt Jacobs

import Foundation
import SwiftData

@Model
public class TodoDTO {

    var identifier: UUID
    var title: String
    var content: String
    var isCompleted: Bool

    public init(identifier: UUID, title: String, content: String, isCompleted: Bool = false) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.isCompleted = isCompleted
    }
}

// MARK: Mapping to Domain

extension Todo {
    public init(dto: TodoDTO) {
        self.id = dto.identifier.uuidString
        self.title = dto.title
        self.content = dto.content
        self.isCompleted = dto.isCompleted
    }

    public init(dto: CDTodoDTO) {
        self.id = dto.identifier?.uuidString ?? ""
        self.title = dto.title ?? ""
        self.content = dto.content ?? ""
        self.isCompleted = dto.isCompleted
    }
}

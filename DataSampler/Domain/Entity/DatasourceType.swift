// Created by Kurt Jacobs

import Foundation

public enum DatasourceType: Int {
    case swiftData = 0
    case coreData = 1

    public init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .swiftData
        case 1:
            self = .coreData
        default:
            self = .coreData
        }
    }
}

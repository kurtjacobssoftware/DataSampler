// Created by Kurt Jacobs

import Foundation

public class UserDefaultsDatasourceTypeProvider: DatasourceTypeProvider {

    private var userDefaults = UserDefaults.standard
    private var key: String = "selectedDatasource"

    public var selectedDatasource: DatasourceType {
        get {
                let storedValue = userDefaults.integer(forKey: key)
                let storedDatasourceType = DatasourceType(rawValue: storedValue)
                return storedDatasourceType ?? .coreData
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: key)
        }
    }
}

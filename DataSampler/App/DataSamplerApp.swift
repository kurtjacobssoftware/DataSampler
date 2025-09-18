// Created by Kurt Jacobs

import SwiftUI

@main
struct DataSamplerApp: App {

    private var dependencyContainer: DependencyContainer = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            TodoListingView(viewModel: TodoListingViewModel(dependencies: dependencyContainer))
                .environmentObject(dependencyContainer)
        }
    }
}

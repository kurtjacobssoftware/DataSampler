// Created by Kurt Jacobs

import SwiftUI

struct TodoListingView: View {
    @EnvironmentObject var dependencies: DependencyContainer

    @State var viewModel: TodoListingViewModel
    @State var isShowingCreateTodoView: Bool = false
    @State var errorAlertDeleteFailedPresented: Bool = false
    @State var errorAlertUpdateFailedPresented: Bool = false

    var body: some View {
        NavigationStack {
            List(viewModel.todos, id: \.id) { todo in
                HStack {
                    VStack(alignment: .leading) {
                        Text(todo.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(todo.content)
                            .font(.body)
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 22)
                        .frame(width: 44, height: 44)
                        .foregroundStyle(todo.isCompleted ? .green : .red)
                        .padding(.trailing)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    do {
                        try viewModel.update(todo: todo, completed: !todo.isCompleted)
                    }
                    catch {
                        errorAlertUpdateFailedPresented = true
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete", systemImage: "xmark.bin") {
                        withAnimation {
                            do {
                                try viewModel.delete(todo: todo)
                            } catch {
                                errorAlertDeleteFailedPresented = true
                            }
                        }
                    }
                    .tint(.red)
                }
            }
            .refreshable {
                viewModel.load()
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button("Text", systemImage: "plus.circle") {
                            withAnimation {
                                isShowingCreateTodoView = true
                            }
                        }
                            switch viewModel.currentDatasource() {
                            case .swiftData:
                                Button("Text", systemImage: "swiftdata") {
                                    withAnimation {
                                        viewModel.updateCurrentDatasource(to: .coreData)
                                    }
                                }
                                .tint(.green)
                            case .coreData:
                                Button("Text", systemImage: "swiftdata") {
                                    withAnimation {
                                        viewModel.updateCurrentDatasource(to: .swiftData)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
        .sheet(isPresented: $isShowingCreateTodoView) {
            CreateNewTodoView(isShowingCreateTodoView: $isShowingCreateTodoView, viewModel: CreateNewTodoViewModel(dependencies: dependencies))
                .environmentObject(dependencies)
        }
        .alert(isPresented: $errorAlertDeleteFailedPresented) {
            Alert(title: Text("Error"), message: Text("Delete Failed"), dismissButton: .default(Text("Got it!")))
        }
        .alert(isPresented: $errorAlertUpdateFailedPresented) {
            Alert(title: Text("Error"), message: Text("Update Failed"), dismissButton: .default(Text("Got it!")))
        }
    }
}

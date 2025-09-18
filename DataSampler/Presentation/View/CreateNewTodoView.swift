// Created by Kurt Jacobs

import SwiftUI

struct CreateNewTodoView: View {
    @EnvironmentObject var dependencies: DependencyContainer

    @State var title: String = ""
    @State var content: String = ""
    @Binding var isShowingCreateTodoView: Bool

    @State var viewModel: CreateNewTodoViewModel
    @State var errorAlertSaveFailedPresented: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Title")
                            .font(.caption2)
                            .fontWeight(.bold)
                        TextField("Title", text: $title)
                    }
                    VStack(alignment: .leading) {
                        Text("Content")
                            .font(.caption2)
                            .fontWeight(.bold)
                        TextField("Content", text: $content)
                    }
                }
                Section {
                        Button {
                            do {
                                try viewModel.save(todo: Todo(id: "", title: title, content: content, isCompleted: false))
                            } catch {
                                errorAlertSaveFailedPresented = true
                            }
                            isShowingCreateTodoView = false
                        } label: {
                            Text("Save")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "xmark.circle") {
                        isShowingCreateTodoView = false
                    }
                }
            })
            .navigationTitle("Create New Todo")
            .alert(isPresented: $errorAlertSaveFailedPresented) {
                Alert(title: Text("Error"), message: Text("Save Failed"), dismissButton: .default(Text("Got it!")))
            }
        }
    }
}

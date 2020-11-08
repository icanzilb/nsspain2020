import ComposableArchitecture
import Foundation
import SwiftUI
import TimelaneCore

struct Todo: Equatable, Identifiable {
    var description = ""
    let id: UUID
    var isComplete = false
}

extension Todo {
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id
    }
}

enum TodoAction: Equatable {
    case checkBoxToggled
    case textFieldChanged(String)
}

struct TodoEnvironment {}

let subscription = Timelane.Subscription(name: "TodoReducer")

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { todo, action, _ in    
    subscription.event(value: .value(String(describing: action)))

    switch action {
    case .checkBoxToggled:
        todo.isComplete.toggle()
        return .none
        
    case let .textFieldChanged(description):
        todo.description = description
        return .none
    }
}

struct TodoView: View {
    let store: Store<Todo, TodoAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button(action: { viewStore.send(.checkBoxToggled) }) {
                    Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
                }
                .buttonStyle(PlainButtonStyle())
                
                TextField(
                    "Untitled Todo",
                    text: viewStore.binding(get: { $0.description }, send: TodoAction.textFieldChanged)
                )
            }
            .foregroundColor(viewStore.isComplete ? .gray : nil)
        }
    }
}

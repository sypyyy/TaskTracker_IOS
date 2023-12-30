//
//  TodoViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/27.
//

import Foundation

class TodoViewModel : ObservableObject{
   
    static var shared = TodoViewModel()
    private var parentModel = TaskMasterViewModel.shared
    private var persistenceModel : PersistenceController = PersistenceController.preview
    public var selectedDate: Date = Date()
    
    ///是否有数据改变
    public var statDataChanged = false {
        didSet {
            if statDataChanged {
                HabitTrackerStatisticViewModel.shared.respondToDataChange()
            }
        }
    }
}

//日期更改， 又master viewModel下发
extension TodoViewModel {
    
    func selectDate(date: Date) {
        selectedDate = date
        objectWillChange.send()
    }
}

//Todo CRUD
extension TodoViewModel {
    func getDaySpecificTodos(date: Date) -> [ToDoModel] {
        return persistenceModel.getTodoOfDay(day: date).map {todo in
            .init(todo: todo)
        }
    }
    
    func createNewTodo(todo: ToDoModel) -> CreateTodoResult {
        persistenceModel.createTodo(dataModel: todo)
    }
}

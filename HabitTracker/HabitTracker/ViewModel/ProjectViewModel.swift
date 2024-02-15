//
//  ProjectViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/4.
//

import Foundation

class ProjectViewModel : ObservableObject{
   
    static var shared = ProjectViewModel()
    private var parentModel = TaskMasterViewModel.shared
    private var persistenceModel : PersistenceController = PersistenceController.preview
}

//Todo CRUD
extension ProjectViewModel {
    func getAllProjects() -> [ProjectModel] {
        return persistenceModel.getAllProjects().map {proj in
                .init(project: proj)
        }
    }
    
    func createNewProject(project: ProjectModel) -> CreateProjectResult {
        persistenceModel.createProject(dataModel: project)
    }
}

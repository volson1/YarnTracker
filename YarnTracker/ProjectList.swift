//
//  ProjectList.swift
//  YarnTracker
//
//  Created by Virginia Olson on 9/19/24.
//

import Foundation

class ProjectList: ObservableObject {
    @Published var projects : [Project] {
        didSet {
            if let encodedData = try? JSONEncoder().encode(projects) {
                UserDefaults.standard.set(encodedData, forKey: "data")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "data") {
            if let decodedData = try? JSONDecoder().decode([Project].self, from: data) {
                projects = decodedData
                return
            }
        }
        projects = []
    }
    
    func ToString() {
        for project in projects {
            print(project)
        }
    }
    
    func getIndex(project: Project) -> Int {
        var count: Int = 0
        
        for loopProj in projects {
            if loopProj.id == project.id {
                return count
            }
            count += 1
        }
        return -1
    }
    
    func numOfToDoProjects() -> Int {
        var count: Int = 0
        
        for loopProj in projects {
            if loopProj.stage == "To do" {
                count += 1
            }
        }
        
        return count
    }
    
    func numOfProjects() -> Int {
        return projects.count
    }
}

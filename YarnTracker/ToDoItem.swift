//
//  ToDoList.swift
//  ToDoList
//
//  Created by Virginia Olson on 9/9/24.
//

import Foundation

class ToDoList: ObservableObject {
    
    @Published var items : [ToDoItem] {
        didSet {
            if let encodedData = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encodedData, forKey: "data")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "data") {
            if let decodedData = try? JSONDecoder().decode([ToDoItem].self, from: data) {
                items = decodedData
                return
            }
        }
        items = []
    }
}

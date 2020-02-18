//
//  TaskStore.swift
//  Taskly
//
//  Created by Yamada, Masaya on 2/18/20.
//  Copyright © 2020 Yamada, Masaya. All rights reserved.
//

import Foundation

class TaskStore {
    
    // using host two section
    // two tasks array
    var tasks = [[Task](), [Task]()]
    
    // add tasks
    func add(_ task:Task, at index: Int, isDone: Bool = false){
        
        let section = isDone ? 1 : 0
        
        tasks[section].insert(task, at: index)
        
    }
    
    //remove tasks
    func removeTask(at index: Int, isDone: Bool = false) -> Task {
        
        let section = isDone ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
    
}

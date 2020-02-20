//
//  TasksUtility.swift
//  Taskly
//
//  Created by Yamada, Masaya on 2/20/20.
//  Copyright © 2020 Yamada, Masaya. All rights reserved.
//

import Foundation

class TasksUtility {
    
    private static let key = "tasks"
    
    // active
    private static func articve(_ tasks: [[Task]]) -> NSData {
        
        // MEMO: return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
        return try! NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) as NSData
        
    }
    
    
    // fetch
    static func fetch() -> [[Task]]? {
        
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? [[Task]] ?? [[]]
        
    }
        
    // save
    static func save(_ tasks: [[Task]]) {
        
        // Archive
        let archiveTasks = articve(tasks)
        
        // Set object for key
        UserDefaults.standard.set(archiveTasks, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    
}

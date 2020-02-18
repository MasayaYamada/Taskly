//
//  Task.swift
//  Taskly
//
//  Created by Yamada, Masaya on 2/18/20.
//  Copyright © 2020 Yamada, Masaya. All rights reserved.
//

import Foundation

class Task {
    
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
    
    
}

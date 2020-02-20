//
//  TasksController.swift
//  Taskly
//
//  Created by Yamada, Masaya on 2/18/20.
//  Copyright © 2020 Yamada, Masaya. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            // Get data
            taskStore.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
            
            // Reload table view
            tableView.reloadData()
        }
        
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        // Setting up our alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        // Set up the actions
        let addAction = UIAlertAction(title: "Add Task", style: .default) { _ in
            
            // Grab text field  text
            guard let name = alertController.textFields?.first?.text else { return }
            
            // Create task
            let newTask = Task(name: name)
            
            // Add task
            self.taskStore.add(newTask, at: 0)
            
            // Reload data in table view
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            // Save
            TasksUtility.save(self.taskStore.tasks)
            
            
        }
        
        
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Canncel", style: .cancel)
        
        
        // Add the text Field
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        // Add the actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        //Present
        present(alertController, animated: true)
        
    }
    
    // This function is doing specific action
    @objc private func handleTextChanged(_ sender: UITextField) {
        
        // Grab the alert controller and add action
        //Guards are so so helpful and I use them all the time because it won't allow any code below the guard
        //statement to be executed unless certain conditions are met.
        guard let alertController = presentedViewController as? UIAlertController,
            let addAction = alertController.actions.first,
            let text = sender.text
            else { return }
        
        // Enable ad action based on if text is empty or contains whitespace
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
        
    }
    
    
}

//MARK: - DataSource
extension TasksController {
    
    // sectionのヘッダータイトルを調整
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-Do" : "Done"
    }
    
    // table のセクション内にある数を設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    // table内のcellの数を設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    // cell 内の設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
    
}

// MARK: - Delegate
extension TasksController {
    // sectionのヘッダーの高さを調整
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    // TableViewのスワイプ時の効果 right swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            // Determine whether the task `isDone`
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            
            // Remove the task from the appropriate array
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            // Reload table view
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Save
            TasksUtility.save(self.taskStore.tasks)
           
            // Indicate that the action was performed
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //left swipe
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) {
            (action, sourceView, completionHandler) in
            
            // Toggle that the task is done
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            // Remove the task from the array containing todo tasks
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            
            // add the task from the array containing done tasks
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Reload table view
            self.taskStore.add(doneTask, at: 0, isDone: true)
            
            // Indicate the action was performed
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            
            // Save
            TasksUtility.save(self.taskStore.tasks)
                       
            
            completionHandler(true)
            
        }
        
        doneAction.image = UIImage(named: "done")
        doneAction.backgroundColor = .green
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
        
    }
}

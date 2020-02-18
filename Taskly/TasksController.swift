//
//  TasksController.swift
//  Taskly
//
//  Created by Yamada, Masaya on 2/18/20.
//  Copyright © 2020 Yamada, Masaya. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {

    var taskStore: TaskStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        // Setting up our alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        // Set up the actions
        let addAction = UIAlertAction(title: "Add Task", style: .default, handler: nil)
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
    
    // sectionのヘッダーの高さを調整
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
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

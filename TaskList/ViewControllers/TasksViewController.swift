//
//  ViewController.swift
//  TaskList
//
//  Created by Alexey Efimov on 05.05.2025.
//

import UIKit

protocol TaskEditorViewControllerDelegate: AnyObject {
    func didCreate(task: String)
}

final class TasksViewController: UITableViewController {
    
    private let cellID = "taskCell"
    private var tasks: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
}

// MARK: - UITableViewDataSource
extension TasksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Setup UI
private extension TasksViewController {
    func setupNavigationBar() {
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .milkBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - TaskEditorViewControllerDelegate
extension TasksViewController: TaskEditorViewControllerDelegate {
    func didCreate(task: String) {
        let index = IndexPath(row: tasks.count, section: 0)
        tasks.append(task)
        tableView.insertRows(at: [index], with: .automatic)
    }
}

// MARK: - Actions
private extension TasksViewController {
    @objc func addTask() {
        let taskEditorVC = TaskEditorViewController(delegate: self)
        present(taskEditorVC, animated: true)
    }
}

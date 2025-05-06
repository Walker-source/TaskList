//
//  TaskEditorViewController.swift
//  TaskList
//
//  Created by Alexey Efimov on 05.05.2025.
//

import UIKit

final class TaskEditorViewController: UIViewController {
    // MARK: - Properties
    unowned var delegate: TaskEditorViewControllerDelegate
    
    private lazy var task = getTask()
    
    // MARK: - UI Elements
    private lazy var taskTextField = makeTextField()
    private lazy var taskNoteField = makeTaskNoteField()
    
    private lazy var saveButton = FilledButton.make(
        title: "Save Button",
        color: .milkBlue,
        action: save()
    )
    private lazy var cancelButton = FilledButton.make(
        title: "Cancel",
        color: .milkRed,
        action: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
    )
    private lazy var taskStatusSwitcher = makeTaskStatusSwitch()
    
    // MARK: - Initializers
    init(delegate: TaskEditorViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraints()
    }
}

// MARK: - Setup Task Model
private extension TaskEditorViewController {
    func getTask() -> Task {
        let task = Task(id: UUID(), title: "", note: "", creationDate: Date(), dueDate: nil, isComplete: false)
        return task
    }
}

// MARK: - Setup UI
private extension TaskEditorViewController {
    func setConstraints() {
        applyConstraints(to: taskTextField, top: Metrics.VSpacing.large)
        applyConstraints(to: taskNoteField, relativeTo: taskTextField, top: Metrics.VSpacing.medium, height: 100)
        applyConstraints(to: taskStatusSwitcher, relativeTo: taskNoteField, top: Metrics.VSpacing.medium)
        applyConstraints(to: saveButton, relativeTo: taskStatusSwitcher, top: Metrics.VSpacing.medium)
        applyConstraints(to: cancelButton, relativeTo: saveButton, top: Metrics.VSpacing.medium)
    }
}

// MARK: - UI Factory
private extension TaskEditorViewController {
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New Task..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    func makeTaskNoteField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray
        
        return textField
    }
    func makeTaskStatusSwitch() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "In Progress", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Completed", at: 1, animated: true)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setEnabled(true, forSegmentAt: 0)
        
        return segmentedControl
    }
}

// MARK: - Actions
private extension TaskEditorViewController {
    func save() -> UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            task.title = taskTextField.text ?? ""
            task.note = taskNoteField.text ?? ""
            
            delegate.didCreate(task: task )
            dismiss(animated: true)
        }
    }
}

final class PreviewDelegate: TaskEditorViewControllerDelegate {
    func didCreate(task: Task) {}
}

#Preview {
    TaskEditorViewController(delegate: PreviewDelegate())
}

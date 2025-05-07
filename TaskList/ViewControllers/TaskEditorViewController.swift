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
    
    // MARK: - Private Properties
    private lazy var task = setupTaskModel()
    
    // MARK: - UI Elements
    private lazy var taskTextField = makeTextField()
    private lazy var taskNoteField = makeTaskNoteField()
    private lazy var date = makeDatePicker()
    
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
//        saveButtonActivate()
    }
}


// MARK: - Setup Task Model
private extension TaskEditorViewController {
    func setupTaskModel() -> Task {
        let task = Task(id: UUID(), title: "", note: "", creationDate: Date(), dueDate: nil, isComplete: false)
        return task
    }
}

// MARK: - Setup UI
private extension TaskEditorViewController {
    func setConstraints() {
        applyConstraints(to: taskTextField, top: Metrics.VSpacing.large)
        applyConstraints(to: taskNoteField, relativeTo: taskTextField, top: Metrics.VSpacing.medium, height: 100)
        applyConstraints(to: date, relativeTo: taskNoteField, top: Metrics.VSpacing.medium)
        applyConstraints(to: taskStatusSwitcher, relativeTo: date, top: Metrics.VSpacing.medium)
        applyConstraints(to: saveButton, relativeTo: taskStatusSwitcher, top: Metrics.VSpacing.medium)
        applyConstraints(to: cancelButton, relativeTo: saveButton, top: Metrics.VSpacing.medium)
    }
    func saveButtonActivate() {
        if ((taskTextField.text?.isEmpty) != nil) {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

// MARK: - UI Factory
private extension TaskEditorViewController {
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New Task..."

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
        
        segmentedControl.insertSegment(action: setTaskInProgress(), at: 0, animated: true)
        segmentedControl.insertSegment(action: setTaskCompleted(), at: 1, animated: true)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setEnabled(true, forSegmentAt: 0)
        segmentedControl.setTitle("In Progress", forSegmentAt: 0)
        segmentedControl.setTitle("Completed", forSegmentAt: 1)
        
        return segmentedControl
    }
    func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }
}

// MARK: - Actions
private extension TaskEditorViewController {
    func save() -> UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            task.title = taskTextField.text ?? ""
            task.note = taskNoteField.text ?? ""
            task.creationDate = date.date
            
            delegate.didCreate(task: task )
            dismiss(animated: true)
        }
    }
    func setTaskInProgress() -> UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            task.isComplete = false
        }
    }
    func setTaskCompleted() -> UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            task.isComplete = true
        }
    }
}

final class PreviewDelegate: TaskEditorViewControllerDelegate {
    func didCreate(task: Task) {}
}

#Preview {
    TaskEditorViewController(delegate: PreviewDelegate())
}

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
    
    // MARK: - UI Elements
    private lazy var taskTextField = makeTextField()
    
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

// MARK: - Setup UI
private extension TaskEditorViewController {
    func setConstraints() {
        applyConstraints(to: taskTextField, top: Metrics.VSpacing.large)
        applyConstraints(to: saveButton, relativeTo: taskTextField, top: Metrics.VSpacing.medium)
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
}

// MARK: - Actions
private extension TaskEditorViewController {
    func save() -> UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            delegate.didCreate(task: taskTextField.text ?? "")
            dismiss(animated: true)
        }
    }
}

final class PreviewDelegate: TaskEditorViewControllerDelegate {
    func didCreate(task: String) {}
}

#Preview {
    TaskEditorViewController(delegate: PreviewDelegate())
}

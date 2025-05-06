//
//  Task.swift
//  TaskList
//
//  Created by Denis Lachikhin on 06.05.2025.
//

import Foundation

struct Task {
    var id: UUID
    var title: String
    var note: String?
    var creationDate: Date
    var dueDate: Date?
    var isComplete: Bool
}

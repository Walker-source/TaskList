//
//  Task.swift
//  TaskList
//
//  Created by Denis Lachikhin on 06.05.2025.
//

import Foundation

struct Task {
    let id: UUID
    let title: String
    let note: String?
    let creationDate: Date
    let dueDate: Date?
    let isComplete: Bool
}

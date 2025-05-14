//
//  Word.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import Foundation
import SwiftData

extension Word {
    enum WordStatus: String, Codable, CaseIterable {
        case notAttempted = "notAttempted"
        case correct = "correct"
        case incorrect = "incorrect"
    }
}
@Model
final class Word {
    var id: UUID
    var title: String
    var meaning: String
    var createdDate: Date
    var _status: String
    var status: WordStatus {
        get {
            WordStatus(rawValue: _status) ?? .notAttempted
        }
        set {
            _status = newValue.rawValue
        }
    }
    
    init(title: String, meaning: String, status: WordStatus) {
        self.id = UUID()
        self.title = title
        self.meaning = meaning
        self._status = status.rawValue
        self.createdDate = .now
    }
}

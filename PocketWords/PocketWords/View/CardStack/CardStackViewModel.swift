//
//  CardStackViewModel.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class CardStackViewModel {
    private func checkMeaning(input: String, with word: Word) -> Bool {
        input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==
        word.meaning.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func submitAnswer(_ input: String, for word: Word, context: ModelContext) {
        word.status = checkMeaning(input: input, with: word) ? .correct : .incorrect
        do {
            try context.save()
        } catch {
            print("Error on saving context: \(error)")
        }
    }
    
    func addWord(_ word: Word, context: ModelContext) {
        context.insert(word)
        do {
            try context.save()
        } catch {
            print("Error on saving context: \(error)")
        }
    }
}

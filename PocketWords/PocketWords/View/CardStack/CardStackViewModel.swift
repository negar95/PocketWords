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
    var xp: String = "0"
    var xpProgress: Double = 0
    func checkMeaning(_ input: String, with word: Word) -> Bool {
        input.trimmingCharacters(in: .whitespacesAndNewlines)
            .caseInsensitiveCompare(
                word.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
            ) == .orderedSame
    }
    func submitAnswer(_ status: Word.WordStatus, for word: Word, context: ModelContext) {
        word.status = status
        do {
            try context.save()
        } catch {
            print("Error on saving context: \(error)")
        }
        updateXP(context: context)
    }
    func addWord(_ word: Word, context: ModelContext) {
        context.insert(word)
        do {
            try context.save()
        } catch {
            print("Error on saving context: \(error)")
        }
        updateXP(context: context)
    }
    func updateXP(context: ModelContext) {
        let correctDescriptor = FetchDescriptor(predicate: #Predicate<Word> { $0._status == "correct" } )
        let allDescriptor = FetchDescriptor<Word>()
        guard let correctCount = try? context.fetchCount(correctDescriptor),
              let allCount = try? context.fetchCount(allDescriptor)
        else { return }
        xp = String(correctCount * 10)
        xpProgress = min(1, Double(correctCount) / Double(max(1, allCount)))
    }
}

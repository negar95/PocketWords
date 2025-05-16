//
//  CardStackViewModelTests.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/14/25.
//

import XCTest
import SwiftData
@testable import PocketWords

final class CardStackViewModelTests: XCTestCase {

    var modelContainer: ModelContainer!
    var context: ModelContext!
    var viewModel: CardStackViewModel!

    override func setUpWithError() throws {
        modelContainer = try ModelContainer(for: Word.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        context = ModelContext(modelContainer)
        viewModel = CardStackViewModel()
    }

    override func tearDownWithError() throws {
        modelContainer = nil
        context = nil
        viewModel = nil
    }

    func testCheckMeaning_CorrectMatch() {
        let word = Word(title: "Bonjour", meaning: "Hello", status: .notAttempted)
        let result = viewModel.checkMeaning("  hello ", with: word)
        XCTAssertTrue(result)
    }

    func testCheckMeaning_IncorrectMatch() {
        let word = Word(title: "Bonjour", meaning: "Hello", status: .notAttempted)
        let result = viewModel.checkMeaning("Hi", with: word)
        XCTAssertFalse(result)
    }

    func testAddWord_InsertsAndSaves() {
        let word = Word(title: "Bonjour", meaning: "Hello", status: .notAttempted)
        viewModel.addWord(word, context: context)

        let fetch = FetchDescriptor<Word>()
        let count = try? context.fetchCount(fetch)
        XCTAssertEqual(count, 1)
    }

    func testSubmitAnswer_UpdatesStatusAndXP() throws {
        let word = Word(title: "Bonjour", meaning: "Hello", status: .notAttempted)
        context.insert(word)
        try context.save()
        viewModel.submitAnswer(.correct, for: word, context: context)
        let updated = try context.fetch(FetchDescriptor<Word>()).first
        XCTAssertEqual(updated?.status, .correct)
        XCTAssertEqual(viewModel.xp, 1.0)
    }

    func testUpdateXP_CalculatesCorrectly() throws {
        let correctWord = Word(title: "Hola", meaning: "Hello", status: .correct)
        let wrongWord = Word(title: "Ciao", meaning: "Hi", status: .incorrect)
        context.insert(correctWord)
        context.insert(wrongWord)
        try context.save()
        viewModel.updateXP(context: context)
        XCTAssertEqual(viewModel.xp, 0.5, accuracy: 0.001)
    }
}

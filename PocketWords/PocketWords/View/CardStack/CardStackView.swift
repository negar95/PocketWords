//
//  CardStackView.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import SwiftUI
import SwiftData

private enum Constants {
    enum Card {
        static let baseSize: CGFloat = 300
        static let sizeStep: CGFloat = 20
        static let cornerRadius: CGFloat = 15
        static let opacityStep: CGFloat = 0.1
    }
    
    enum Layout {
        static let cardSpacing: CGFloat = 50
        static let progressWidth: CGFloat = 300
        static let progressHeight: CGFloat = 50
        static let progressBackgroundOpacity: CGFloat = 0.3
    }
}

struct CardStackView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<Word> { $0._status == "notAttempted" } )
    private var notAttemptedWords: [Word]
    
    @State private var showingNewCard = false
    @State private var viewModel = CardStackViewModel()
    
    private func getCardView(index: Int, word: Word) -> some View {
        let idx = CGFloat(index)
        let sizeDiff = idx * Constants.Card.sizeStep
        let size = max(0, Constants.Card.baseSize - sizeDiff)
        let offset = min(size, sizeDiff)
        let opacity = 1 - (Constants.Card.opacityStep * idx)

        return CardView(
            title: word.title,
            description: word.meaning
        ) { input in
            viewModel.checkMeaning(input, with: word)
        } submit: { status in
            viewModel.submitAnswer(status, for: word, context: context)
        }
        .frame(width: size, height: size)
        .background(Color.accentColor.opacity(opacity))
        .cornerRadius(Constants.Card.cornerRadius)
        .offset(y: offset)
        .opacity(opacity)
        .allowsHitTesting(index == 0)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: Constants.Layout.cardSpacing) {
                HStack {
                    ProgressView(value: viewModel.xpProgress)
                        .progressViewStyle(.linear)
                        .foregroundStyle(Color.accentColor)

                    Text("\(viewModel.xp)" + "xp")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                .padding()
                .frame(width: Constants.Layout.progressWidth, height: Constants.Layout.progressHeight)
                .background(Color.accentColor.opacity(Constants.Layout.progressBackgroundOpacity))
                .cornerRadius(Constants.Card.cornerRadius)

                ZStack {
                    ForEach(Array(notAttemptedWords.enumerated().reversed()), id: \.element.id) { index, word in
                        getCardView(index: index, word: word)
                    }

                    Text("No cards to review!")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .opacity(notAttemptedWords.isEmpty ? 1 : 0)
                }
            }
            .navigationTitle("PocketWords")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewCard = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Add new flashcard")
                }
            }
            .sheet(isPresented: $showingNewCard) {
                NewCardView { newWord in
                    viewModel.addWord(newWord, context: context)
                    showingNewCard = false
                }
            }
            .onAppear {
                viewModel.updateXP(context: context)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let context = container.mainContext
        let sampleWords = [
            Word(title: "Abate", meaning: "To lessen", status: .notAttempted),
            Word(title: "Benevolent", meaning: "Kind and generous", status: .notAttempted),
            Word(title: "Capricious", meaning: "Impulsive and unpredictable", status: .notAttempted)
        ]
        sampleWords.forEach { context.insert($0) }

        return CardStackView()
            .modelContainer(container)
    } catch {
        return Text("Failed to load preview: \(error.localizedDescription)")
    }
}

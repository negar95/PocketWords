//
//  CardStackView.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import SwiftUI
import SwiftData

struct CardStackView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<Word> { $0._status == "notAttempted" } )
    private var notAttemptedWords: [Word]
    
    @State private var showingNewCard = false
    @State private var viewModel = CardStackViewModel()
    
    private func getCardView(index: Int, word: Word) -> some View {
        let _index = CGFloat(index)
        let sizeDiff = _index * 20
        let size = max(0, 300 - sizeDiff)
        let offset = min(size, sizeDiff)
        let opacity = 1 - (0.1 * _index)

        return CardView(title: word.title) { input in
            let check = viewModel.checkMeaning(input, with: word)
            return check
        } submit: { status in
            viewModel.submitAnswer(status, for: word, context: context)
        }
        .frame(width: size, height: size)
        .background(Color.accentColor.opacity(opacity))
        .cornerRadius(15)
        .offset(y: offset)
        .opacity(opacity)
        .allowsHitTesting(index == 0)
    }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("XP:")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    ProgressView(value: viewModel.xp)
                        .progressViewStyle(.linear)
                        .foregroundStyle(Color.accentColor)
                    
                }
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.accentColor.opacity(0.3))
                .cornerRadius(15)
                
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

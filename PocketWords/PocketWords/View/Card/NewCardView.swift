//
//  NewCardView.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import SwiftUI

struct NewCard {
    let title: String?
    let description: String?
}

struct NewCardView: View {
    @State private var titleText = ""
    @State private var descriptionText = ""
    @FocusState private var titleIsFocused: Bool
    @FocusState private var descriptionIsFocused: Bool
    
    let done: (Word) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter the word", text: $titleText)
                .lineLimit(0)
                .multilineTextAlignment(.leading)
                .focused($titleIsFocused)
                .submitLabel(.next)
                .onSubmit {
                    titleIsFocused = false
                    descriptionIsFocused = true
                }
                .accessibilityLabel("Word input field")
                .accessibilityHint("Type the new word and tap Next.")
                .accessibilityValue(titleText)
                .accessibilityElement(children: .combine)
                .padding(5)
                .background(.white.opacity(0.5))
                .cornerRadius(15)

            TextField("Enter the meaning", text: $descriptionText)
                .lineLimit(0)
                .multilineTextAlignment(.leading)
                .focused($descriptionIsFocused)
                .submitLabel(.done)
                .onSubmit {
                    submitWord()
                }
                .accessibilityLabel("Meaning input field")
                .accessibilityHint("Type the meaning of the word and tap Done.")
                .accessibilityValue(descriptionText)
                .padding(5)
                .background(.white.opacity(0.5))
                .cornerRadius(15)

            Button {
                submitWord()
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
            }
            .accessibilityLabel("Submit word and meaning")
            .accessibilityHint("Adds this card to your vocabulary list.")
            .accessibilityAddTraits(.isButton)
        }
        .padding(20)
        .frame(maxWidth: 300, maxHeight: 300)
        .background(Color.accentColor.opacity(0.5))
        .cornerRadius(15)
        .accessibilityElement(children: .contain)
    }
    
    private func submitWord() {
        guard !titleText.isEmpty, !descriptionText.isEmpty else { return }
        done(Word(title: titleText, meaning: descriptionText, status: .notAttempted))
    }
}

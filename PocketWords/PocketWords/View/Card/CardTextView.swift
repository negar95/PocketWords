//
//  CardTextView.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import SwiftUI

struct CardTextView: View {
    @State private var inputText = ""
    @FocusState private var fieldIsFocused: Bool
    let done: (String) -> Void

    var body: some View {
        HStack {
            TextField("Enter the meaning", text: $inputText)
                .lineLimit(0)
                .multilineTextAlignment(.leading)
                .focused($fieldIsFocused)
                .submitLabel(.done)
                .onSubmit {
                    done(inputText)
                    fieldIsFocused = false
                }
                .accessibilityLabel("Meaning input field")
                .accessibilityHint("Type the meaning of the word and tap Done to submit your answer.")
                .accessibilityValue(inputText)
            Button {
                done(inputText)
                fieldIsFocused = false
            } label: {
                Image(systemName: "checkmark.circle.fill")
            }
            .accessibilityLabel("Submit meaning")
            .accessibilityHint("Submits your answer when pressed.")
            .accessibilityAddTraits(.isButton)
        }
        .padding(5)
        .background(.white.opacity(0.6))
        .accessibilityElement()
    }
}

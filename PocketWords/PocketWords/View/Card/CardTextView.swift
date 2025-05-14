//
//  CardTextView.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import SwiftUI

struct CardTextView: View {
    @State private var inputText = ""
    @State var result: Bool? = nil
    @FocusState private var fieldIsFocused: Bool
    let check: (String) -> Bool
    let submit: (Word.WordStatus) -> Void
    
    var body: some View {
        ZStack {
            if let result {
                if result {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.green)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                submit(.correct)
                            }
                        }
                } else {
                    Image(systemName: "xmark.seal.fill")
                        .foregroundStyle(Color.red)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                submit(.incorrect)
                            }
                        }
                }
            } else {
                HStack {
                    TextField("Enter the meaning", text: $inputText)
                        .lineLimit(0)
                        .multilineTextAlignment(.leading)
                        .focused($fieldIsFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            fieldIsFocused = false
                            result = check(inputText)
                        }
                        .accessibilityLabel("Meaning input field")
                        .accessibilityHint("Type the meaning of the word and tap Done to submit your answer.")
                        .accessibilityValue(inputText)
                    Button {
                        fieldIsFocused = false
                        result = check(inputText)
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
    }
}

//
//  CardView.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import SwiftUI

struct CardView: View {
    @State private var flipped = false
    let title: String
    let description: String
    let check: (String) -> Bool
    let submit: (Word.WordStatus) -> Void
    
    var body: some View {
        ZStack {
            Color.clear
            if flipped {
                Text(description)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .accessibilityElement()
                    .accessibilityLabel("Card description: \(description)")
                    .accessibilityHint("The description of the card.")
            } else {
                VStack {
                    Text(title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityElement()
                        .accessibilityLabel("Card title: \(title)")
                        .accessibilityHint("Tap to see the description")
                    CardTextView(check: check, submit: submit)
                        .cornerRadius(15)
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Card submit")
                        .accessibilityHint("Enter the meaning and submit")
                }
            }
        }
        .padding(20)
        .contentShape(Rectangle())
        .onTapGesture { flipped.toggle() }
        .rotation3DEffect(
            flipped ? Angle(degrees: 180) : .zero,
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.default, value: flipped)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "Flip Card") {
            flipped.toggle()
        }
    }
}

#Preview {
    CardView(
        title: "Example",
        description: "Description",
        check: { _ in true },
        submit: { _ in }
    )
    .frame(width: 300, height: 300)
    .background(Color.accentColor.opacity(1))
    .cornerRadius(15)
}

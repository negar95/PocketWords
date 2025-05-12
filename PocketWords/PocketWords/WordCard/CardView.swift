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
    let done: (String) -> Void
    
    var body: some View {
        ZStack {
            if flipped {
                CardTextView(done: done)
                    .cornerRadius(15)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Back of the card")
                    .accessibilityHint("Enter the meaning and submit to flip")
            } else {
                Text(title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityElement()
                    .accessibilityLabel("Word card: \(title)")
                    .accessibilityHint("Double tap to flip and enter the meaning.")
            }
        }
        .padding(20)
        .frame(maxWidth: 300, maxHeight: 300)
        .background(flipped ? Color.indigo : Color.teal)
        .cornerRadius(15)
        .rotation3DEffect(
            flipped ? Angle(degrees: 180) : .zero,
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.default, value: flipped)
        .onTapGesture {
            flipped.toggle()
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "Flip Card") {
            flipped.toggle()
        }
    }
}

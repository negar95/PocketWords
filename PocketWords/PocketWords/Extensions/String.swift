//
//  String.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/14/25.
//

extension String {
    var withoutWhitespace: String {
        self.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
    }
}

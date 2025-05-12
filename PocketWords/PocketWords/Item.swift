//
//  Item.swift
//  PocketWords
//
//  Created by Negar Moshtaghi on 5/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

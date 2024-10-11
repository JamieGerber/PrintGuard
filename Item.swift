//
//  Item.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 24.08.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date?
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

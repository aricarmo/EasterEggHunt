//
//  Item.swift
//  EasterEggHunt
//
//  Created by Arilson Simplicio on 03/06/25.
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

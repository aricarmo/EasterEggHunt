//
//  GameProgress.swift
//  EasterEggHunt
//
//  Created by Arilson Simplicio on 03/06/25.
//

import SwiftData

@Model
class GameProgress {
    var currentClue: Int = 1
    var totalFound: Int = 0
    var isSpecialModeUnlocked: Bool = false
    
    init() {}
}

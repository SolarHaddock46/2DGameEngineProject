//
//  LevelThumbViewModel.swift
//  glide Demo
//


import Foundation

class LevelThumbViewModel {
    
    let level: Level
    var levelName: String {
        return level.name
    }
    
    var levelInfo: String {
        return level.info
    }
    
    init(level: Level) {
        self.level = level
    }
    
}

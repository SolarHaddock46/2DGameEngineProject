//
//  SingleLevelSectionViewModel.swift
//  glide Demo
//


import Foundation

class SingleLevelSectionViewModel {
    let section: Section
    let levelThumbViewModels: [LevelThumbViewModel]
    
    init(section: Section) {
        self.section = section
        self.levelThumbViewModels = section.levels.map { LevelThumbViewModel(level: $0) }
    }
}

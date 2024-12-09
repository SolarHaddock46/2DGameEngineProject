//
//  LevelSectionsViewModel.swift
//  YAEngine Demo
//


import Foundation

struct Levels: Codable {
    let sections: [Section]
}

struct Section: Codable {
    let name: String
    let info: String
    let levels: [Level]
}

struct Level: Codable {
    let file: String
    let name: String
    let scene: String
    let info: String
    let isSKS: Bool?
}

class LevelSectionsViewModel {
    
    private let sections: [Section]
    let sectionViewModels: [SingleLevelSectionViewModel]
    
    init() {
        guard let url = Bundle.main.url(forResource: "Levels", withExtension: ".json") else {
            print("(error) levels file couldn't be found")
            self.sections = []
            self.sectionViewModels = []
            return
        }
        
        do {
            let jsonData = try Data.init(contentsOf: url, options: Data.ReadingOptions.alwaysMapped)
            let decoder = JSONDecoder()
            
            let levels = try decoder.decode(Levels.self, from: jsonData)
            self.sections = levels.sections
            self.sectionViewModels = sections.map { SingleLevelSectionViewModel(section: $0) }
        } catch {
            print(error)
            self.sections = []
            self.sectionViewModels = []
        }
    }
    
}

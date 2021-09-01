//
//  LevelService.swift
//  Riddles
//
//  Created by Ivan Zakharov on 1/9/21.
//

import Foundation

struct ResponseData: Decodable {
    var levels: [Level]
}
struct Level: Decodable {
    var name: String
    var answer: String
    var task: String
}

class LevelService {
    func loadJson(filename fileName: String) -> [Level]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.levels
            }
            catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}

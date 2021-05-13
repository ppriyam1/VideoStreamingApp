//
//  JouralModel.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/6/21.
//

import Foundation

// MARK: - JournalModel
struct JournalModel: Codable {
    let journal: [Journal]

    enum CodingKeys: String, CodingKey {
        case journal = "Journal"
    }
}

// MARK: - Journal
struct Journal: Codable {
    let chapterName, comment, date: String
    let level: Int
    let userName: String

    enum CodingKeys: String, CodingKey {
        case chapterName = "ChapterName"
        case comment = "Comment"
        case date = "Date"
        case level = "Level"
        case userName = "UserName"
    }
}

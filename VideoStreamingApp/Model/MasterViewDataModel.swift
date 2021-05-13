//
//  MasterViewDataModel.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/3/21.
//

import Foundation

struct MasterViewDataModel {
    
    var masterViewData : [MasterViewData] = []
    
    init() {
        let infoPlistPath = Bundle.main.path(forResource: "Chapters", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: infoPlistPath)
        let data = (dict!["Chapters"]! as! [[String: String]])
        
        for data in data {
            masterViewData.append(MasterViewData(chapterName: data["name"]!, chapterUrl: data["url"]!))
        }
    }
}

struct MasterViewData {
    var chapterName: String
    var chapterUrl: String
}

//
//  RecentModel.swift
//  Smashtag
//
//  Created by di on 17.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation



struct RecentMentions {
    
    private let key  = "RecentMentions"
    private let maxCount = 100
    fileprivate var recentMentions = [String]()
    private let ud = UserDefaults.standard
    
    private func save(){
        guard !recentMentions.isEmpty else {return}
        ud.set(recentMentions,forKey: key)
        print(" DEB1: save arr: \(recentMentions)")
    }
    
    fileprivate mutating func load(){
        recentMentions = ud.stringArray(forKey: key) ?? []
        print("DEB1: load arr: \(recentMentions)")
    }
    
    init() {
        load()
    }
    
    mutating func appendUnique(mention: String) {
        load()
        if recentMentions.contains(mention) {
            recentMentions = recentMentions.filter{ $0 != mention }
        }
        
        if recentMentions.count > maxCount {
          _ = recentMentions.dropFirst()
        }
        
        recentMentions.append(mention)
        save()
    }
    
    
    
}

extension RecentMentions {

    var count : Int { return recentMentions.count  }
    
    
    subscript(index : Int) -> String {
        mutating get {
            load()
            guard !recentMentions.isEmpty else {return ""}
            return recentMentions[recentMentions.count - 1 - index]
        }
        
    }

}

//
//  RecentModel.swift
//  Smashtag
//
//  Created by di on 17.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation

protocol Loadble {
    mutating func load()
   
}


struct RecentMentions : Loadble {
    
    private let key  = "RecentMentions"
    private let maxCount = 100
    private var recentMentions = [String]()
    private let ud = UserDefaults.standard
    
    private func save(){
        guard !recentMentions.isEmpty else {return}
        ud.set(recentMentions,forKey: key)
        print(" DEB1: save arr: \(recentMentions)")
    }
    
    mutating func load(){
        recentMentions = ud.stringArray(forKey: key) ?? []
        print("DEB1: load arr: \(recentMentions)")
    }
    
    mutating func appendUnique(mention: String) {
        
        if recentMentions.contains(mention) {
            recentMentions = recentMentions.filter{ $0 != mention }
        }
        
        if recentMentions.count > maxCount {
          _ = recentMentions.dropFirst()
        }
        
        recentMentions.append(mention)
        save()
    }
    
    var count : Int { return recentMentions.count  }
    
    
    subscript(index : Int) -> String {
        get {
            guard !recentMentions.isEmpty else {return ""}
            return recentMentions[recentMentions.count - 1 - index]
        }
        
    }
    
}

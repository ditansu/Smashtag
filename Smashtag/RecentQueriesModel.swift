//
//  RecentQueriesModel.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 20.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation



struct RecentQueries {
    
    private let key  = "RecentMentions"
    private let maxCount = 100
    fileprivate var recentQueries = [String]()
    private let ud = UserDefaults.standard
    
    private func save(){
        guard !recentQueries.isEmpty else {return}
        ud.set(recentQueries,forKey: key)
        print(" DEB1: save arr: \(recentQueries)")
    }
    
    fileprivate mutating func load(){
        recentQueries = ud.stringArray(forKey: key) ?? []
        print("DEB1: load arr: \(recentQueries)")
    }
    
    init() {
        load()
    }
    
    mutating func appendUnique(mention: String) {
        load()
        if recentQueries.contains(mention) {
            recentQueries = recentQueries.filter{ $0 != mention }
        }
        
        if recentQueries.count > maxCount {
            _ = recentQueries.dropFirst()
        }
        
        recentQueries.append(mention)
        save()
    }
    
    
    
}

extension RecentQueries {
    
    var count : Int { return recentQueries.count  }
    
    
    subscript(index : Int) -> String {
        mutating get {
            load()
            guard !recentQueries.isEmpty else {return ""}
            return recentQueries[recentQueries.count - 1 - index]
        }
        
    }
    
}

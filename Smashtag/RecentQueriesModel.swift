//
//  RecentQueriesModel.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 20.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation



struct RecentQueries {
    
    private let key  = "RecentQueries0"
    private let maxCount = 100
    fileprivate var recentQueries = [String]()
    private let ud = UserDefaults.standard
    
    fileprivate func save(){
        guard !recentQueries.isEmpty else {return}
        ud.set(recentQueries,forKey: key)
       // print(" DEB1: save arr: \(recentQueries)")
    }
    
    fileprivate mutating func load(){
        recentQueries = ud.stringArray(forKey: key) ?? []
       // print("DEB1: load arr: \(recentQueries)")
    }
    
    init() {
        load()
    }
    
    mutating func appendUnique(mention: String) {
        load()
        if recentQueries.contains(mention) {
            recentQueries = recentQueries.filter{ $0 != mention }
        }
        
        if recentQueries.count >= maxCount {
            recentQueries = recentQueries.dropFirst().map{ $0 }
        }
        
        recentQueries.append(mention)
        save()
    }
    
    
    
}

extension RecentQueries {
    
    mutating func remove(_ mention : String){
       
        load()
        //print("DEB1: before remove: [\(mention)]: \(recentQueries)")
        if recentQueries.contains(mention) {
            recentQueries = recentQueries.filter{ $0 != mention }
        }
        //print("DEB1: after remove: [\(mention)]: \(recentQueries)")
        save()
    
    }
    
    
    var count : Int {
        mutating get {
            load()
            return recentQueries.count
        }
    }
    
    
    subscript(index : Int) -> String {
        mutating get {
            load()
            guard !recentQueries.isEmpty else {return ""}
            return recentQueries[recentQueries.count - 1 - index]
        }
        
    }
    
}

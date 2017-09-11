//
//  TermTable.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 10.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class TermTable: NSManagedObject {
    
    class func findOrCreateTerm(search term: String, in context : NSManagedObjectContext)throws -> TermTable
    {
        let request : NSFetchRequest<TermTable> = TermTable.fetchRequest()
        
        request.predicate = NSPredicate(format: "term = %@", term)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "TermTable.findOrCreateTerm -- database inconsistency" )
                return matches.first!
            }
            
        } catch {
            throw error
        }
        
        let termTable =  TermTable(context: context)
        
        termTable.term = term
        termTable.timeStamp = Date().currentTimeStamp
        return termTable
        
    }
    
    
    class func findAndUpdateTimestamp(search term: String, in context : NSManagedObjectContext)throws -> Bool
    {
        let request : NSFetchRequest<TermTable> = TermTable.fetchRequest()
        
        request.predicate = NSPredicate(format: "term = %@", term)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "TermTable.findOrCreateTerm -- database inconsistency" )
                let termTable = matches.first!
                termTable.timeStamp = Date().currentTimeStamp
                return true
            }
            
        } catch {
            throw error
        }
        
        return false 
    }
    
    
}

extension Date {

    var currentTimeStamp : Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }

}

//
//  PopularityTable.swift
//  Smashtag
//
//  Created by di on 13.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class PopularityTable: NSManagedObject {
    
    
//    
//    class func findOrCreatePopularity(search term: String, in context : NSManagedObjectContext)throws -> TermTable
//    {
//        let request : NSFetchRequest<TermTable> = TermTable.fetchRequest()
//        
//        request.predicate = NSPredicate(format: "term = %@", term)
//        
//        do {
//            let matches = try context.fetch(request)
//            
//            if matches.count > 0 {
//                assert(matches.count == 1, "TermTable.findOrCreateTerm -- database inconsistency" )
//                return matches.first!
//            }
//            
//        } catch {
//            throw error
//        }
//        
//        let termTable =  TermTable(context: context)
//        
//        termTable.term = term
//        termTable.timeStamp = Date().currentTimeStamp
//        return termTable
    
}

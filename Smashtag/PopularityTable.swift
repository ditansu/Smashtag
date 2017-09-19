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
    
    
    class func createOrUpdatePopularity(by mention : MentionTable, for term: TermTable, in context : NSManagedObjectContext)throws -> PopularityTable {
        let request : NSFetchRequest<PopularityTable> = PopularityTable.fetchRequest()
        request.predicate = NSPredicate(format: "mention.mention = %@ and term.term = %@", mention.mention!,term.term!)
        
        let matches = try? context.fetch(request)
        
        if !matches!.isEmpty {
            assert(matches?.count == 1, "createOrUpdatePopularity -- database inconsistency" )
            let popularity = matches!.first
            popularity?.popularity += 1
            return popularity!
        }
        
        let popularity = PopularityTable(context: context)
        popularity.popularity = 0
        popularity.mention = mention
        popularity.term = term
        return popularity
        
    }

    
}

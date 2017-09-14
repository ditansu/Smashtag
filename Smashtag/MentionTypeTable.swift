//
//  MentionTypeTable+CoreDataClass.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 14.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation
import CoreData


class MentionTypeTable: NSManagedObject {

    
    class func findOrCreateMentionType(type : String, in context : NSManagedObjectContext)throws -> MentionTypeTable
    {
        let request : NSFetchRequest<MentionTypeTable> = MentionTypeTable.fetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "MentionTypeTable.findOrCreateMentionType -- database inconsistency" )
                return matches.first!
            }
            
        } catch {
            throw error
        }
        
        let mentionTypeTable    = MentionTypeTable(context : context)
        mentionTypeTable.type = type
        return mentionTypeTable
        
    }

    
    
}

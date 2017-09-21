//
//  MentionTable.swift
//  Smashtag
//
//  Created by di on 07.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class MentionTable: NSManagedObject {
    
    // to twitterInfo : Twitter.Tweet
    
    class func findOrCreateMention(matching tweetMention : String, in context : NSManagedObjectContext)throws -> MentionTable
    {
        let request : NSFetchRequest<MentionTable> = MentionTable.fetchRequest()
        request.predicate = NSPredicate(format: "mention = %@", tweetMention)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "Mention.findOrCreateMention -- database inconsistency" )
                
                let mention = matches.first!
                return mention
            }
            
        } catch {
            throw error
        }
        
        let mention = MentionTable(context : context)
        
        mention.mention = tweetMention
        
        return mention
        
    }
    
    class func deleteOrUpdateMention(for mention : MentionTable,  in context : NSManagedObjectContext) throws {
        
        do {
            
            try PopularityTable.deleteOrUpdatePopularity(by: mention, in: context)
            
            
            
        } catch {
            throw error
        }
 
        
    }
    
    
}

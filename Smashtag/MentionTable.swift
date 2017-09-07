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
                
                mention.popularity += 1
                
                return mention
            }
            
        } catch {
            throw error
        }
        
        let mention = MentionTable(context : context)
        
        mention.mention = tweetMention
        mention.popularity = 1
        
        return mention
        
    }
    
}

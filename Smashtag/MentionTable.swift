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
    
    class func findOrCreateMention(matching twitterInfo : Twitter.Tweet, in context : NSManagedObjectContext)throws -> [MentionTable]
    {
        let request : NSFetchRequest<MentionTable> = MentionTable.fetchRequest()
        request.predicate = NSPredicate(format: "mention = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency" )
                return matches.first!
            }
            
        } catch {
            throw error
        }
        
        let mention = MentionTable(context : context)
        
        
        
        //tweet.unique = twitterInfo.identifier
        //tweet.text   = twitterInfo.text
        //tweet.created = twitterInfo.created as NSDate
        
        //link one Twitter to many Tweets
        // tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        
        
        return mention
        
    }
    
}

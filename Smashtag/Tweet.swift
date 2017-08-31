//
//  Tweet.swift
//  Smashtag
//
//  Created by di on 29.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo : Twitter.Tweet, in context : NSManagedObjectContext)throws -> Tweet
    {
        let request : NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency" )
                return matches.first!
            }
            
        } catch {
            throw error
        }
        
        let tweet = Tweet(context : context)
        tweet.unique = twitterInfo.identifier
        tweet.text   = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        
        //link one Twitter to many Tweets
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        
        return tweet
        
    }
    
}
 

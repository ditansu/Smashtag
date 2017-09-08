//
//  TweetTable.swift
//  Smashtag
//
//  Created by di on 07.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//
import UIKit
import CoreData
import Twitter

class TweetTable: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo : Twitter.Tweet, in context : NSManagedObjectContext)throws -> TweetTable
    {
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "TweetTable.findOrCreateTweet -- database inconsistency" )
                return matches.first!
            }
            
        } catch {
            throw error
        }
        
        let tweet = TweetTable(context : context)
        
        tweet.unique = twitterInfo.identifier
        tweet.text   = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        
        for mentions in twitterInfo.tweetMentions {
            guard let userOrHashtag = mentions.userOrHashtag else { continue }
            for mention in userOrHashtag {
                if let mentionTable = try? MentionTable.findOrCreateMention(matching: mention, in: context) {
                    mentionTable.addToTweets(tweet)
                }
            }
        }
        
        return tweet
        
    }
    
}

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
    
    class func findOrCreateTweet(search term: String, matching twitterInfo : Twitter.Tweet, in context : NSManagedObjectContext)throws -> TweetTable
    {
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 { //  tweet alredy exist
                assert(matches.count == 1, "TweetTable.findOrCreateTweet -- database inconsistency" )
            
                let tweet = matches.first!
                
                request.predicate = NSPredicate(format: "unique = %@ and terms.term = %@", twitterInfo.identifier,term)
                
                let matchesTerm = try context.fetch(request)
                
                if matchesTerm.count == 0 { // but this term is not yet linked with tweet
                    if let termTable = try? TermTable.findOrCreateTerm(search: term, in: context) {
                        tweet.addToTerms(termTable)
                    }
                } else { // link is exist, so we are need update a term's timestamp
                   _ = try? TermTable.findAndUpdateTimestamp(search: term, in: context)
        
                }
            
                return tweet
            }
            
        } catch {
            throw error
        }
        
        let tweet =  TweetTable(context: context)
        
        tweet.unique  = twitterInfo.identifier
        tweet.text    = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        
        if let termTable = try? TermTable.findOrCreateTerm(search: term, in: context) {
            tweet.addToTerms(termTable)
        }
        
        tweet.tweeter = try? TwitterUserTable.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
    
        
        for mentions in twitterInfo.tweetMentions {
            guard let userOrHashtag = mentions.userOrHashtag else { continue }
            for mention in userOrHashtag {
                if let mentionTable = try? MentionTable.findOrCreateMention(matching: mention, in: context) {
                    tweet.addToMentions(mentionTable)
                    //mentionTable.
                }
            }
        }
        
        return tweet
        
    }
    
}

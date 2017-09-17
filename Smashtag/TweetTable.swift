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
            
            if matches.count > 0 { //  tweet alredy exist
                assert(matches.count == 1, "TweetTable.findOrCreateTweet -- database inconsistency" )
            
                let tweet = matches.first!
                
                return tweet
            }
            
        } catch {
            throw error
        }
        
        let tweet =  TweetTable(context: context)
        
        tweet.unique  = twitterInfo.identifier
        tweet.text    = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        
        tweet.tweeter = try? TwitterUserTable.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)

        
        return tweet
        
    }
    
    class func createTweetsBatch(from tweets : [Twitter.Tweet], in context : NSManagedObjectContext)throws -> Bool
    {
        
        let tweetsID = tweets.map{ $0.identifier }
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique IN %@", tweetsID)
        
        do {
            let matches = try context.fetch(request)
            guard matches.count > 0 else { return false }
            
            print("DEB1: createTweetsBatch matches.count: \(matches.count)")
            
            let matchedTweetsID = matches.map{ $0.unique! }
            let newTweetsID = tweetsID.filter{ !matchedTweetsID.contains($0) }
            
            print("DEB1: createTweetsBatch newTweetsID.count: \(newTweetsID.count)")
            
            var debugInsetcCount = 0
            
            try newTweetsID.forEach{
                let tweetID = $0
                print("DEB1: createTweetsBatch try insert \(tweetID)")
                guard let twitterInfo = tweets.first(where: {$0.identifier == tweetID}) else {
                    print("ERROR: createTweetsBatch newTweetsID.forEach for tweetID \(tweetID)")
                    return
                }
                
                let tweet = TweetTable(context: context)
                tweet.unique  = twitterInfo.identifier
                tweet.text    = twitterInfo.text
                tweet.created = twitterInfo.created as NSDate
                tweet.tweeter = try TwitterUserTable.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
                print("DEB1: createTweetsBatch inserted: \(twitterInfo)")
                debugInsetcCount += 1
            }
            
            return !newTweetsID.isEmpty
        } catch {
            throw error
        }
       // return false
    }
    
    
}

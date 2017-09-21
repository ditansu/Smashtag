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
    
    
    class func isTweetTermPairExist(twitter identifier: String, by term: String, in context : NSManagedObjectContext) -> Bool {
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@ and terms.term CONTAINS[cd] %@", identifier,term)
        guard let matchesTerm = try? context.fetch(request) else {return false}
        return !matchesTerm.isEmpty
    }
    
    
    
    class func getTweetsIdWithoutTerm(from tweets : [Twitter.Tweet], for term: String, in context : NSManagedObjectContext)throws -> [String] {
        
        let tweetsId = tweets.map{ $0.identifier }
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique IN %@ and terms.term CONTAINS[cd] %@", tweetsId, term)
        do {
            let matchedTweetsID = try context.fetch(request).map{ $0.unique! }
            return tweetsId.filter{ !matchedTweetsID.contains($0) }
        } catch {
            throw error
        }
        
    }
    
    class func updateTweetsByTerm(for tweets : [Twitter.Tweet], for term: String, in context : NSManagedObjectContext)throws {
        let tweetsID = tweets.map{ $0.identifier }
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique IN %@", tweetsID)
        
        do {
            let tweetsForUpdate = try context.fetch(request)
            print("DEB1: updateTweetsByTerm tweetsForUpdate.count: \(tweetsForUpdate.count)")
            let termRec = try TermTable.findOrCreateTerm(search: term, in: context)
            tweetsForUpdate.forEach{ tweet in
                tweet.addToTerms(termRec)
            }
        } catch {
            throw error
        }
    }
    
    
    class func createTweetsBatch(from tweets : [Twitter.Tweet], in context : NSManagedObjectContext)throws -> Bool
    {
        
        let tweetsID = tweets.map{ $0.identifier }
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "unique IN %@", tweetsID)
        
        do {
            let matches = try context.fetch(request)
            print("DEB1: createTweetsBatch matches.count: \(matches.count)")
            
            let matchedTweetsID = matches.map{ $0.unique! }
            let tweetsForCreate = tweetsID.filter{ !matchedTweetsID.contains($0) }
            
            print("DEB1: createTweetsBatch tweetsForCreate.count: \(tweetsForCreate.count)")
            
            
            try tweetsForCreate.forEach{
                let tweetID = $0
                //print("DEB1: createTweetsBatch try insert \(tweetID)")
                guard let twitterInfo = tweets.first(where: {$0.identifier == tweetID}) else {
                    print("ERROR: createTweetsBatch newTweetsID.forEach for tweetID \(tweetID)")
                    return
                }
                
                let tweet = TweetTable(context: context)
                tweet.unique  = twitterInfo.identifier
                tweet.text    = twitterInfo.text
                tweet.created = twitterInfo.created as NSDate
                tweet.tweeter = try TwitterUserTable.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
                
                let mentions = twitterInfo.tweetMentions.flatMap{ $0.userOrHashtag}.flatMap{ $0.mentions }
                
                try mentions.forEach{ mention in
                    let mentionRec = try MentionTable.findOrCreateMention(matching: mention, in: context)
                    mentionRec.addToTweets(tweet)
                }
                
                //print("DEB1: createTweetsBatch inserted: \(twitterInfo)")
                
            }
            
            return !tweetsForCreate.isEmpty
        } catch {
            throw error
        }
        // return false
    }
    
    
    
    
    class func deleteStaleTweets(after date : Date, in context : NSManagedObjectContext) throws {
        
        let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
        request.predicate = NSPredicate(format: "created < %@", date as NSDate)
        do {
            
            if let tweetCount = try? context.count(for: TweetTable.fetchRequest()){
                print("DEB1: deleteStaleTweets before delete count: \(tweetCount)  ")
            }
            
            let matches = try context.fetch(request)
            print("DEB1: deleteStaleTweets will deleted: \(matches.count)")
            
            matches.forEach{tweet  in
                
                tweet.mentions?.forEach{mention in
                    try MentionTable.deleteOrUpdateMention(for: mention, in: context)
                    
                }
                
                
                context.delete(tweet)
                //print("DEB1: delete  tweet \(tweet)")
                
            }
            
            
            if let tweetCount = try? context.count(for: TweetTable.fetchRequest()){
                print("DEB1: deleteStaleTweets after delete count: \(tweetCount)  ")
            }

            
        } catch {
            throw error
        }
        
        
    }
    
}

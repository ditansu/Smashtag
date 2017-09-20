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
        do {
            let matches = try context.fetch(request)
            
            if !matches.isEmpty {
                assert(matches.count == 1, "createOrUpdatePopularity -- database inconsistency" )
                let popularity = matches.first
                popularity?.popularity += 1
                print("DEB1: inc popularity to \(String(describing: popularity?.popularity)) for tem: \(String(describing: term.term)) with  mention: \(String(describing: mention.mention))")
                return popularity!
            }
            
            let popularity = PopularityTable(context: context)
            popularity.popularity = 0
            popularity.mention = mention
            popularity.term = term
            print("DEB1: set popularity to \(popularity.popularity) for tem: \(String(describing: term.term)) with  mention: \(String(describing: mention.mention))")
            return popularity
        } catch {
            throw error
        }
    }
    
    
    class func calculateAndSavePopularity(for tweets: [Twitter.Tweet], for term : String, in context : NSManagedObjectContext)throws {
        
        do {
            let termRecord = try TermTable.findOrCreateTerm(search: term, in: context)
            
            try tweets.forEach{ tweet in
                
                let userOrHashtags = tweet.tweetMentions.flatMap{ $0.userOrHashtag }
                print("DEB1: try cacl popularity for \(tweet) with userOrHashtags [\(userOrHashtags)] ")
                try userOrHashtags.forEach{userOrHashtag in
                    try userOrHashtag.mentions.forEach{ mention in
                        let mentionRecord = try MentionTable.findOrCreateMention(matching: mention, in: context)
                        _ = try PopularityTable.createOrUpdatePopularity(by: mentionRecord, for: termRecord, in: context)
                        let typeMentionTable = try MentionTypeTable.findOrCreateMentionType(type: userOrHashtag.title, in: context)
                        typeMentionTable.addToMentions(mentionRecord)
                    }
                }
            }
        } catch {
            throw error
        }
    }
    
}

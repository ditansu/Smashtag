//
//  PopularityManage.swift
//  Smashtag
//
//  Created by di on 13.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation
import CoreData
import Twitter





protocol PopularityManageProtocol {
    func add(from tweet : Twitter.Tweet,by term : String)
    func get(mention indexPath : IndexPath) -> (mention : String, popularity : Int)?
}

protocol DataLinkWithTableViewController {
    var delegat : NSFetchedResultsControllerDelegate? {get set}
    var numberOfSections : Int { get }
    var numberOfRowsInSection : Int { get }
    var titleForHeaderInSection : String? { get}
    var sectionIndexTitles : [String]? { get }
}


struct PopularityManage: PopularityManageProtocol {
    
    
    private let context : NSManagedObjectContext
    private var fetchedResultsController : NSFetchedResultsController<PopularityTable>?
    
    
    init(context : NSManagedObjectContext){
     self.context = context
    }
    
    func add(from tweet: Twitter.Tweet, by term: String) {
     
        func isTweetTermPairExist(twitter identifier: String, by term: String) -> Bool {
            let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
            request.predicate = NSPredicate(format: "unique = %@ and terms.term = %@", identifier,term)
            guard let matchesTerm = try? context.fetch(request) else {return false}
            return !matchesTerm.isEmpty
        }
        
       
        func createOrUpdatePopularity(by mention : MentionTable, for term: TermTable)throws {
            let request : NSFetchRequest<PopularityTable> = PopularityTable.fetchRequest()
            request.predicate = NSPredicate(format: "mentions.mention = %@ and terms.term = %@", mention.mention!,term.term!)
            
            let matches = try? context.fetch(request)
            
            if !matches!.isEmpty {
                assert(matches?.count == 1, "createOrUpdatePopularity -- database inconsistency" )
                let popularity = matches!.first
                popularity?.popularity += 1
            } else {
                let popularity = PopularityTable(context: context)
                popularity.popularity = 0
                popularity.mentions = mention
                popularity.terms = term
            }
            
        }
        
        
   //MAKR: - Main func
        
        if !isTweetTermPairExist(twitter: tweet.identifier, by: term) {
        
            guard let tweetRecord = try? TweetTable.findOrCreateTweet(matching: tweet, in: context) else {return}
            guard let termRecord = try? TermTable.findOrCreateTerm(search: term, in: context) else {return}
            
            tweetRecord.addToTerms(termRecord)
            
            for mentions in tweet.tweetMentions {
                guard let userOrHashtag = mentions.userOrHashtag else { continue }
                for mention in userOrHashtag {
                    
                    if let mentionRecord = try? MentionTable.findOrCreateMention(matching: mention, in: context) {
                
                      _ = try? createOrUpdatePopularity(by: mentionRecord, for: termRecord)
                        
                    }
                }
            }

            
            
        }
        
        
    }
    
    func get(mention indexPath: IndexPath) -> (mention: String, popularity: Int)? {
        
        
        
        return nil
    }

    

    

}

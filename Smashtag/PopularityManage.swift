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





protocol TableViewDataSourceProtocol {
    var  numberOfSections : Int { get }
    var  sectionIndexTitles : [String]? { get }
    func numberOfRows(in section : Int) -> Int
    func titleForHeader(in section : Int) -> String?
    func sectionForSectionIndexTitle(title: String, at index: Int)->Int
}

protocol PopularityManageProtocol:  TableViewDataSourceProtocol {
    func calculateAndSavePopularity(from tweet : Twitter.Tweet,by term : String)
    mutating func fetchMentions(for term : String, with popularity : Int)
    func returnMentionPopularity(at indexPath: IndexPath) -> (mention : String, popularity : Int)?
}


struct PopularityManager: PopularityManageProtocol {
    
    private let context : NSManagedObjectContext
    private var fetchedResultsController : NSFetchedResultsController<PopularityTable>?
    var delegat : NSFetchedResultsControllerDelegate?
    
    init(context : NSManagedObjectContext){
        self.context = context
    }
    
    func calculateAndSavePopularity(from tweet: Twitter.Tweet, by term: String) {
        
        func isTweetTermPairExist(twitter identifier: String, by term: String) -> Bool {
            let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
            request.predicate = NSPredicate(format: "unique = %@ and terms.term CONTAINS[cd] %@", identifier,term)
            guard let matchesTerm = try? context.fetch(request) else {return false}
            return !matchesTerm.isEmpty
        }
        
        
        func createOrUpdatePopularity(by mention : MentionTable, for term: TermTable)throws -> PopularityTable {
            let request : NSFetchRequest<PopularityTable> = PopularityTable.fetchRequest()
            request.predicate = NSPredicate(format: "mention.mention = %@ and term.term = %@", mention.mention!,term.term!)
            
            let matches = try? context.fetch(request)
            
            if !matches!.isEmpty {
                assert(matches?.count == 1, "createOrUpdatePopularity -- database inconsistency" )
                let popularity = matches!.first
                popularity?.popularity += 1
                return popularity!
            }
            
            let popularity = PopularityTable(context: context)
            popularity.popularity = 0
            popularity.mention = mention
            popularity.term = term
            return popularity
            
        }
        
        //MARK: - Main func
        
        if !isTweetTermPairExist(twitter: tweet.identifier, by: term) {
            
            guard let tweetRecord = try? TweetTable.findOrCreateTweet(matching: tweet, in: context) else {return}
            guard let termRecord  = try? TermTable.findOrCreateTerm(search: term, in: context) else {return}
            
            tweetRecord.addToTerms(termRecord)
            
            for tweetMentions in tweet.tweetMentions {
                
                guard let userOrHashtag = tweetMentions.userOrHashtag else {continue}
                
                //print("DEB1: userOrHashtag  title: \(userOrHashtag.title) for [\(userOrHashtag.mentions)]")
                
                for mention in userOrHashtag.mentions {
                    
                    if let mentionRecord = try? MentionTable.findOrCreateMention(matching: mention, in: context) {
                        _ = try? createOrUpdatePopularity(by: mentionRecord, for: termRecord)
                        let typeMentionTable = try? MentionTypeTable.findOrCreateMentionType(type: userOrHashtag.title, in: context)
                        typeMentionTable!.addToMentions(mentionRecord)
                    }
                }
            }
        }
    }
    
    
    mutating func fetchMentions(for term : String, with popularity : Int) {
        
        let request : NSFetchRequest<PopularityTable> = PopularityTable.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(  // THIS SORTDECRIPTION IS VERY IMPORTANT FOR THE CORRECT CELL PLACED IN HEADER
                key: "mention.type.type",
                ascending: true
            ),
            
            NSSortDescriptor(
                key: "popularity",
                ascending: false
            ),
            
            NSSortDescriptor(
                key: "mention.mention",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )
        ]
        
        request.predicate = NSPredicate(format: "popularity >= %d and term.term = %@", popularity,  term)
        
        fetchedResultsController = NSFetchedResultsController<PopularityTable> (
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "mention.type.type",
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = delegat
        try? fetchedResultsController?.performFetch()
    }
    
    
    func returnMentionPopularity(at indexPath: IndexPath) -> (mention : String, popularity : Int)? {
        
        let popularityRecord = fetchedResultsController?.object(at: indexPath)
        
        
        guard
            let mentionRecord = popularityRecord?.mention,
            let mention = mentionRecord.mention,
            let popularity = popularityRecord?.popularity
            else {
                return nil
        }
        
        let result : (mention : String, popularity : Int)
        result.mention = mention
        result.popularity = Int(popularity)
        
        return result
    }
    
    
    // TableViewDataSourceProtocol
    
    var numberOfSections: Int {
        print("DEB1: numberOfSections: \(fetchedResultsController?.sections?.count ?? 1)")
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        var result = 0
        if  let sections = fetchedResultsController?.sections, sections.count > 0 {
            result = sections[section].numberOfObjects
        } else {
            result = 0
        }
        print("DEB1: numberOfRowsInSection: \(result)")
        return result
    }
    
    func titleForHeader(in section: Int) -> String? {
        var result : String? = nil
        
        if  let sections = fetchedResultsController?.sections, sections.count > 0 {
            result = sections[section].name
        }
        print("DEB1: titleForHeaderInSection: \(String(describing: result))")
        return result
    }
    
    var sectionIndexTitles: [String]? {
        let result = fetchedResultsController?.sectionIndexTitles
        print("DEB1: sectionIndexTitles: \(String(describing: result))")
        return result
    }
    
    
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        let result = fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
        print("DEB1: sectionForSectionIndexTitle: \(result)")
        return result
    }
    
    
    
}

//
//  PopularityManageFast.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 17.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

// For extra task - load\chek if exists by batches

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



private protocol TableViewDataSourceProtocol {
    var  numberOfSections : Int { get }
    var  sectionIndexTitles : [String]? { get }
    func numberOfRows(in section : Int) -> Int
    func titleForHeader(in section : Int) -> String?
    func sectionForSectionIndexTitle(title: String, at index: Int)->Int
}

private protocol PopularityManageProtocol:  TableViewDataSourceProtocol {
    func calculateAndSavePopularity(from tweets : [Twitter.Tweet],by term : String)
    mutating func fetchMentions(for term : String, with popularity : Int)
    func returnMentionPopularity(at indexPath: IndexPath) -> (mention : String, popularity : Int)?
}


struct PopularityManagerFast: PopularityManageProtocol {
    
    private let context : NSManagedObjectContext
    private var fetchedResultsController : NSFetchedResultsController<PopularityTable>?
    var delegat : NSFetchedResultsControllerDelegate?
    
    init(context : NSManagedObjectContext){
        self.context = context
    }
    
   
    
    func calculateAndSavePopularity(from tweets: [Twitter.Tweet], by term: String) {
    
        do {
            let tweetsIdWithoutTerm = try TweetTable.getTweetsIdWithoutTerm(from: tweets, for: term, in: context)
            let tweetsForCalculatePopularity = tweets.filter{  tweetsIdWithoutTerm.contains($0.identifier) }
            _ = try TweetTable.createTweetsBatch(from: tweetsForCalculatePopularity, in: context)
            try TweetTable.updateTweetsByTerm(for: tweetsForCalculatePopularity, for: term, in: context)
            try PopularityTable.calculateAndSavePopularity(for: tweetsForCalculatePopularity, for: term, in: context)
        } catch {
            print("ERROR in PopularityManagerFast: \(error.localizedDescription) ")
            return
        }

    
    }


    
    mutating func fetchMentions(for term : String, with popularity : Int) {
        
        let request : NSFetchRequest<PopularityTable> = PopularityTable.fetchRequest()
        
        request.sortDescriptors = [
            
            NSSortDescriptor(  // THIS SORTDECRIPTION IS VERY IMPORTANT FOR THE CORRECT  PLACED SECTION WITH
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
            sectionNameKeyPath: "mention.type.type", // DON'T FORGET SET NSSortDescriptor !!!
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
    
    
    // MARK: - SectionIndex
    
    func sectionIndexTitle(forSectionName sectionName: String) -> String? {
        guard let result = sectionName.characters.first else {return nil}
        return String(result)
    }
    
    var sectionIndexTitles: [String]? {
        return nil
    }
    
    
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        let result = fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
        print("DEB1: sectionForSectionIndexTitle: \(result)")
        return result
    }
    
    
    
}

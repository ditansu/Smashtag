//
//  PopularityTweetTableViewController.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 09.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class PopularityTweetTableViewController: TweetTableViewController {


    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        
        let dbName = AppDelegate.containerPopularity.persistentStoreCoordinator.persistentStores.first?.configurationName
        let dbPath = AppDelegate.containerPopularity.persistentStoreCoordinator.persistentStores.first?.url?.absoluteString
        
        print("DEB1: Popularity Try loading db with name:\(String(describing: dbName)), by db path: \(String(describing: dbPath))")
        
        updateDatabase(with: newTweets)
        
    }
    
    // MARK:- Load tweets to  DB
    
    private func updateDatabase(with tweets : [Twitter.Tweet]) {
        
        print("DEB1: Popularity start load")
        
        let container = AppDelegate.containerPopularity
        
        container.performBackgroundTask{ [weak self] context in
            
            guard let term = self?.searchText! else {return}
            
            let popularityManager = PopularityManager(context: context)
            
            for tweet in tweets {
                 popularityManager.calculateAndSavePopularity(from: tweet, by: term)
                //TweetTable.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            
            try? context.save()
            print("DEB1: Popularity done load")
            self?.printDatabaseStatistics()
           
        }
        
        
    }
    
    private func printDatabaseStatistics() {
        
        let context = AppDelegate.contextPopularity
        
        context.perform {
            
            let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
            
            if let tweetCount = (try? context.fetch(request))?.count {
                print("DEB1: Popularity: \(tweetCount) tweets")
            }
            
            
            if let popularityCount = try? context.count(for: PopularityTable.fetchRequest()){
                print("DEB1: Popularity count: \(popularityCount)  ")
            }
            
            if let mentionCount = try? context.count(for: MentionTable.fetchRequest()){
                
                print("DEB1: Popularity: \(mentionCount) mentions ")
            }
            
            if let termCount = try? context.count(for: TermTable.fetchRequest()){
                
                print("DEB1: Popularity: \(termCount) terms ")
            }
            
            
            if let userCount = try? context.count(for: TwitterUserTable.fetchRequest()){
                
                print("DEB1: Popularity: \(userCount) users ")
            }
            
            
            
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

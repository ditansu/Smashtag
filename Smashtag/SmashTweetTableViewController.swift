//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 29.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {

    var container : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets : [Twitter.Tweet]) {
        
        print("start load")
        
        container?.performBackgroundTask{ [weak self] context in
            
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done load")
            self?.printDatabaseStatistics()
        }
        
        
    }
 
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            
            context.perform {
                
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                
                
                let request : NSFetchRequest<Tweet> = Tweet.fetchRequest()
                
                if let tweetCount = (try? context.fetch(request))?.count {
                    print("\(tweetCount) tweets")
                }
                
                if let twitterCount = try? context.count(for: TwitterUser.fetchRequest()){
                    
                    print("\(twitterCount) Twitter user ")
                }
            }
        }
        
    }
    
    // MARK: - Navigation
    
    private struct slaveMVC {
        //static let MentionMVC = "MentionMVC"
        static let AnalyzerMVC =  "TweetersMVC"
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case slaveMVC.AnalyzerMVC:
            guard let analyzerMVC = (segue.destination.contents as? SmashTweetersTableViewController) else {return}
            analyzerMVC.mention = searchText
            analyzerMVC.container = container
        default:
            return
        }
        
    }

    
    
}

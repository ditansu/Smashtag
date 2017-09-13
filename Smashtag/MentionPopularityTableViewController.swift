//
//  MentionPopularityTableViewController.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 03.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class MentionPopularityTableViewController: FetchedResultsTableViewController {
    
    
    var fetchedResultsController : NSFetchedResultsController<MentionTable>?
    
    var popularity : Int = 2  { didSet { updateUI()} }
    
    var searchTerm  : String? { didSet{ updateUI()} }
    
    
    
    // MARK: -  Load Tweets
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.delegate = nil
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
//    private var lastTwitterRequest: Twitter.Request?
//    
//    private func twitterRequest() -> Twitter.Request? {
//        if let query = searchTerm, !query.isEmpty {
//            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
//        }
//        return nil
//    }
//    
//    
//    // Core method
//    private func searchForTweets() {
//        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
//            lastTwitterRequest = request
//            request.fetchTweets{ [weak self] newTweets in
//                DispatchQueue.main.async { // return to main queue for update UI (UITable)
//                    if request == self?.lastTwitterRequest { // request is actually now?
//                        self?.insertTweets(newTweets)
//                    }
//                    //self?.refreshControl?.endRefreshing() // REFRESHING
//                }
//                
//            }
//        } else {
//           // self.refreshControl?.endRefreshing() // REFRESHING
//        }
//    }
//    
//    
//    func  insertTweets(_ newTweets : [Twitter.Tweet]){
//        
//        self.tweets.insert(newTweets, at: 0)
//        print("DEB1: Load tweets: \(newTweets.count)")
//        //self.tableView.insertSections([0], with: .fade)
//        updateDatabase(with: newTweets){ [weak self] in self!.updateUI() }
//        
//        
//    }
//    
//    
//    
//    // MARK:- Load tweets to  DB
//    
//    private func updateDatabase(with tweets : [Twitter.Tweet], dataToTable: @escaping  (() -> Void) ) {
//        
//        print("DEB1: Popularity start load")
//        
//        let container = AppDelegate.containerPopularity
//        
//        container.performBackgroundTask{ [weak self] context in
//            
//            for twitterInfo in tweets {
//                _ = try? TweetTable.findOrCreateTweet(matching: twitterInfo, in: context)
//            }
//            
//            try? context.save()
//            print("DEB1: Popularity done load")
//            self?.printDatabaseStatistics()
//            context.perform {
//                dataToTable()
//            }
//        }
//        
//        
//    }
//    
//    private func printDatabaseStatistics() {
//        
//        let context = AppDelegate.contextPopularity
//        
//        context.perform {
//            
//            let request : NSFetchRequest<TweetTable> = TweetTable.fetchRequest()
//            
//            if let tweetCount = (try? context.fetch(request))?.count {
//                print("DEB1: Popularity: \(tweetCount) tweets")
//            }
//            
//            if let mentionCount = try? context.count(for: MentionTable.fetchRequest()){
//                
//                print("DEB1: Popularity: \(mentionCount) mentions ")
//            }
//           
//        }
//    }
    
    
    // MARK:- Show DB in TableView
    
    private func updateUI(){
        
        print("DEB1: start updateUI")
            
        guard let term = searchTerm else {return}
        
        let context = AppDelegate.contextPopularity
        
        let request : NSFetchRequest<MentionTable> = MentionTable.fetchRequest()
        
        request.sortDescriptors = [
            
            NSSortDescriptor(
                key: "popularity",
                ascending: false
            ),
            
            NSSortDescriptor(
                key: "mention",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )
        ]
        
        request.predicate = NSPredicate(format: "any popularity >= %d and terms.term = %@", popularity,  term)
        
        fetchedResultsController = NSFetchedResultsController<MentionTable>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularityCell", for: indexPath)
        
        
        if let popularityRow = fetchedResultsController?.object(at: indexPath) {
            
            cell.textLabel?.text = popularityRow.mention
           // let popularityCount = popularityRow.popularitys
           // cell.detailTextLabel?.text = "\(popularityCount) tweet\((popularityCount == 1) ? "" : "s")"
        }
        return cell
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

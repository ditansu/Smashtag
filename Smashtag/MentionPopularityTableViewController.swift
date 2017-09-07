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

class MentionPopularityTableViewController: UITableViewController {

    
    var searchTerm  : String? {
    
        didSet{
            lastTwitterRequest = nil // REFRESHING
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchTerm
        }
    
    }
    
    
    
    fileprivate var tweets = [Array<Twitter.Tweet>]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    private var lastTwitterRequest: Twitter.Request?
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchTerm, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    
    // Core method
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in
                DispatchQueue.main.async { // return to main queue for update UI (UITable)
                    if request == self?.lastTwitterRequest { // request is actually now?
                        self?.insertTweets(newTweets)
                    }
                    self?.refreshControl?.endRefreshing() // REFRESHING
                }
                
            }
        } else {
            self.refreshControl?.endRefreshing() // REFRESHING
        }
    }
    
    
    func  insertTweets(_ newTweets : [Twitter.Tweet]){
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .fade)
        updateDatabase(with: newTweets)
    }
    
    
    private func updateDatabase(with tweets : [Twitter.Tweet]) {
        
        print("Popularity start load")
        
        let container = AppDelegate.containerPopularity
        
        container.performBackgroundTask{ [weak self] context in
            
            for twitterInfo in tweets {
                _ = try? MentionTable.findOrCreateMention(matching: twitterInfo, in: context)
            }
            
            try? context.save()
            print("Popularity done load")
            self?.printDatabaseStatistics()
        }
        
        
    }
    
    private func printDatabaseStatistics() {
       
            let context = AppDelegate.contextPopularity
            
            context.perform {
                
                //MARK: - CHANGE THAT!!!
                
                //                let request : NSFetchRequest<Tweet> = Tweet.fetchRequest()
                //
                //                if let tweetCount = (try? context.fetch(request))?.count {
                //                    print("Popularity: \(tweetCount) tweets")
                //                }
                //
                //                if let twitterCount = try? context.count(for: TwitterUser.fetchRequest()){
                //
                //                    print("\(twitterCount) Twitter user ")
                //                }
                print("EMPTY")
            }
        
        
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by di on 31.07.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController {
    
    //MARK: MODEL
    
    private var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            print(tweets)
        }
    }
    
    var searchText : String? {
        didSet{
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in
                DispatchQueue.main.async { // return to main queue for update UI (UITable)
                    if request == self?.lastTwitterRequest { // reauest is actually now?
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    self?.refreshControl?.endRefreshing() // REFRESHING
                }
                
            }
        } else {
            self.refreshControl?.endRefreshing() // REFRESHING
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "#stanford"
    }
    
    
    // MARK: - UITableViewDataSource 
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get cell and tweet
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row]
        
        //setup cell by tweet
        cell.textLabel?.text = tweet.text
        cell.detailTextLabel?.text = tweet.user.name
        
        return cell
    }
    
    
}

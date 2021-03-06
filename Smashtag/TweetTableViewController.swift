//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by di on 31.07.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter

//extension Twitter.Tweet : Sequence {
//
//
//}



class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: MODEL
    
    
    // each sub-Array of Tweets
    fileprivate var tweets = [Array<Twitter.Tweet>]()
    
    
   
    
    // public part of our Model
    // when this is set
    // we'll reset our tweets Array
    // to reflect the result of fetching Tweets that match
    var searchText : String? {
        didSet{
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil // REFRESHING
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    private var recentSearchs = RecentQueries()
    
    private var recentSearch : String? {
    
        get {
            return recentSearchs.count > 0 ? recentSearchs[0] : nil
        }
        
        set {
            recentSearchs.appendUnique(mention: newValue!)
        }
    
    }
        
    
    
    // SEARCH
    @IBOutlet var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
            recentSearch = searchTextField.text
        }
        return true
    }
    
    
    // GET TWEETS
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
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
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    //    REFRESHING
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    
    @IBOutlet var backToRootView: UIBarButtonItem!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        searchText = recentSearch
        
    }
    
    @IBAction func backToRootViewAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchText = recentSearch
        backToRootView.isEnabled = self.navigationController!.viewControllers.count > 2
    }
    
    
    // MARK: - Navigation
    
    private struct slaveMVC {
        static let MentionMVC = "MentionMVC"
       // static let AnalyzerMVC =  "TweetersMVC"
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case slaveMVC.MentionMVC :
            
            guard let mentionVC = (segue.destination.contents as? MentionsTableViewController),
                let cell = sender as?  TweetTableViewCell,
                let tweet = cell.tweet  else { return }
            mentionVC.tweetMentions = tweet.tweetMentions  //prepareTweetMentions(tweet: tweet)
            mentionVC.title = tweet.user.screenName
            
        
//        case slaveMVC.AnalyzerMVC:
//            guard let analyzerMVC = (segue.destination.contents as? SmashTweetersTableViewController) else {return}
//                analyzerMVC.mention = searchText
//                analyzerMVC.container = container
        default:
            return
        }
        
        
    }
    
    
}


extension UIViewController {
    
    var contents: UIViewController {
        
        if let tabcon = self as? UITabBarController {
            if let navcon = tabcon.viewControllers?.first as? UINavigationController {
                return navcon.visibleViewController ?? self
            } else {
                return tabcon.viewControllers?.first ?? self
            }
        } else {
            if let navcon = self as? UINavigationController {
                return navcon.visibleViewController ?? self
            } else {
                return self
            }
        }
    }
}



extension TweetTableViewController {

    var tweetImages : Images {
        return tweets.flatMap{$0}.flatMap{
            tweet in tweet.media.map {
                (tweet, $0.url, $0.aspectRatio)
            }
        }
    }


}

extension Twitter.Tweet {

    var tweetMentions : [TweetMentions] {
       
        var result = [TweetMentions]()
        let tweet = self 
        
        if !tweet.media.isEmpty {
            result.append(.image("Изображения", tweet.media.map{ (url: $0.url , aspectRatio: $0.aspectRatio)}))
        }
        
        if !tweet.hashtags.isEmpty {
            result.append(.hashtag("Хештеги", tweet.hashtags.map{$0.keyword}))
        }
        
        if !tweet.urls.isEmpty {
            result.append(.url("Ссылки", tweet.urls.map{$0.keyword}))
        }
        
        if !tweet.userMentions.isEmpty {
            result.append(.user("Пользователи", tweet.userMentions.map{$0.keyword} + [tweet.user.screenName]))
        }
        
        return result
    
    }
    
}






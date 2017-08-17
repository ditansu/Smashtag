//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by di on 31.07.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: MODEL
    
    
    // each sub-Array of Tweets
    private var tweets = [Array<Twitter.Tweet>]()
    
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
            recentSearch = searchText
        }
    }
    
    private var recentSearchs = RecentMentions()
    
    private var recentSearch : String? {
    
        get {
            recentSearchs.load()
            return recentSearchs.count > 0 ? recentSearchs[0] : nil
        }
        
        set {
            recentSearchs.appendUnique(mention: newValue!)
        }
    
    }
        
    
    
    // SEARCH
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    
    // FILL TABLE
    
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
                    if request == self?.lastTwitterRequest { // request is actually now?
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
    
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    
        searchTextField.text = recentSearch
        //searchText = "#stanford"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // searchTextField.text = recentSearch
    }
    
    
    // MARK: - Navigation
    
    
    
    //fill Model for MentionMVC 
    
    func prepareTweetMentions(tweet : Twitter.Tweet)-> [TweetMentions] {
        
        var tweetMentions = [TweetMentions]()
        
        if !tweet.media.isEmpty {
            tweetMentions.append(
                TweetMentions(
                       title: "Изображения",
                        type: MentionType.image,
                    mentions: tweet.media.map{ TweetMentions.Mention.image((url: $0.url , aspectRatio: $0.aspectRatio))}
                )
            )
        }
        
        if !tweet.hashtags.isEmpty {
            tweetMentions.append(
                TweetMentions(
                       title: "Хештеги",
                        type: MentionType.hashtag,
                    mentions: tweet.hashtags.map{ TweetMentions.Mention.text($0.keyword)}
                )
            )
        }
        
        if !tweet.urls.isEmpty {
            tweetMentions.append(
                TweetMentions(
                       title: "Ссылки",
                        type: MentionType.url,
                    mentions: tweet.urls.map{ TweetMentions.Mention.text($0.keyword)}
                )
            )
        }
        
        if !tweet.userMentions.isEmpty {
            tweetMentions.append(
                TweetMentions(
                       title: "Пользователи",
                        type: MentionType.userinfo,
                    mentions: tweet.userMentions.map{ TweetMentions.Mention.text($0.keyword)}
                )
            )
        }
        
        return tweetMentions
    }
    
    private struct slaveMVC {
        static let MentionMVC = "MentionMVC"
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
            mentionVC.tweetMentions = prepareTweetMentions(tweet: tweet)
            mentionVC.title = tweet.user.screenName
            
        //case slaveMVC.someSlaveMVC :
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







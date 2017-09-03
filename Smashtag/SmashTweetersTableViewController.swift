//
//  SmashTweetersTableViewController.swift
//  Smashtag
//
//  Created by di on 30.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTweetersTableViewController: FetchedResultsTableViewController {
    
    // MARK: - Model
    
    var mention : String? { didSet {updateUI() } }
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet {updateUI() } }
    
    var fetchedResultsController : NSFetchedResultsController<TwitterUser>?
    
    private func updateUI(){
        
        
        if let context = container?.viewContext, mention != nil {
            
            let request : NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(
                key: "handle",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@",mention!)
            
            fetchedResultsController = NSFetchedResultsController<TwitterUser>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            
        }
        
    }
    
    private func tweetCountWithMentionBy(_ twitterUser : TwitterUser)-> Int {
    
        let request : NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@",mention!, twitterUser)
        return (try? twitterUser.managedObjectContext!.count(for: request)) ?? 00
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)
        
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.handle
            let tweetCount = tweetCountWithMentionBy(twitterUser)
            cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        return cell
    }
    
    
}

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
    
    var popularity  : Int = 2  { didSet { updateUI()} }
    var searchTerm  : String?  { didSet { updateUI()} }
    var popularityManager = PopularityManager(context: AppDelegate.contextPopularity)
    
    private func updateUI(){
        guard let term = searchTerm else {return}
        popularityManager.delegat = self
        popularityManager.fetchMentions(for: term, with: popularity)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularityCell", for: indexPath)
        
        if let popularityRow = popularityManager.returnMentionPopularity(at: indexPath) {
            cell.textLabel?.text = popularityRow.mention
            let popularityCount = popularityRow.popularity
            cell.detailTextLabel?.text = "\(popularityCount) tweet\((popularityCount == 1) ? "" : "s")"
        }
        return cell
    }
    

    
    
     // MARK: - Navigation
    fileprivate struct slaveMVC {
        static let SearchMVC = "LoadRecentQueriesMVC"
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case slaveMVC.SearchMVC :
            guard let cell = sender as? UITableViewCell else { return }
            let text = cell.textLabel?.text ?? ""
            var recentQueries = RecentQueries()
            recentQueries.appendUnique(mention: text)
        default:
            return
        }
        
        
    }

    
}

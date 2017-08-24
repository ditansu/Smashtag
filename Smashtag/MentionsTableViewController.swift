//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//



import UIKit

class MentionsTableViewController: UITableViewController {
    
    // MODEL: - Tweet mentions model
    
    var tweetMentions : [TweetMentions]?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  tweetMentions?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetMentions![section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetMentions![section].title
    }
    
    
    private struct Cells {
        
        static let image    =   "ImageCell"
        static let user     =   "UserCell"
        static let hashtag  =   "HashtagCell"
        static let url      =   "UrlCell"
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tweetMentions![indexPath.section] {
        case .image(_, let images):
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.image, for: indexPath)
            let url = images[indexPath.row].url
            if let imageCell = cell as? ImageMentionTableViewCell {
                if  imageCell.imageURL != url {
                    imageCell.imageURL = url
                }
            }
            return cell
        case .hashtag(_, let mentions):
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.hashtag, for: indexPath)
            cell.textLabel?.text = mentions[indexPath.row]
            return cell
        case .url(_, let mentions):
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.url, for: indexPath)
            cell.textLabel?.text = mentions[indexPath.row]
            return cell
        case  .user(_, let mentions):
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.user, for: indexPath)
            cell.textLabel?.text = mentions[indexPath.row]
            return cell
        }
        
        
    }
    
    var sectionHeaderHeight : CGFloat = 28.0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tweetMentions![indexPath.section] {
            
        case .image(_, let images):
            
            let aspectRatio = CGFloat(images[indexPath.row].aspectRatio)
            
            let tableWidth = tableView.frame.width
            let tableHeight = tableView.frame.height + tableView.bounds.minY
            sectionHeaderHeight = max(sectionHeaderHeight,tableView.headerView(forSection: indexPath.section)?.frame.height ?? 0.0 )
            
            return min(tableWidth / aspectRatio, tableHeight - sectionHeaderHeight)
            
            
        case .hashtag(_,_), .url(_,_), .user(_,_):
            
            return UITableViewAutomaticDimension
            
        }
        
    }
    
    
    //override func view
    
    
    private var oldView : CGFloat = 0.0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = self.view.bounds.size.width
        
        if width != oldView {
            tableView.reloadData()
            oldView = width
        }
        
        
    }
    
    
   
    
    
    
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
    
     // MARK: - Navigation
    
    private struct Segues {
        
        static let image    =  "ImageSegue"
        static let url      =  "UrlSegue"
        static let user     =  "UserSegue"
        static let hashtag  =  "HashtagSegue"
        
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segues.image:
            guard let imageVC = segue.destination.contents as? ImageShowControl else
            {
                print("ooops! we can't do segue:  \(Segues.image)")
                return
            }
            
            guard let cell = sender as? ImageMentionTableViewCell else {return}
            imageVC.image = cell.imageMentionView.image
            imageVC.title = "Изорбражение"
        case Segues.user:
            guard let cell = sender as? UITableViewCell else {return}
            var recentSearchs = RecentQueries()
            let user = cell.textLabel!.text!
            recentSearchs.appendUnique(mention: user + " OR from:\(user)" )
        case Segues.hashtag:
            guard let cell = sender as? UITableViewCell else {return}
            var recentSearchs = RecentQueries()
            let hashtag = cell.textLabel!.text!
            recentSearchs.appendUnique(mention: hashtag)
        case Segues.url:
            guard let SafariVC = segue.destination.contents as?  SafariViewController else
            {
                print("ooops! we can't do segue:  \(Segues.url)")
                return
            }
            
            guard let cell = sender as? UITableViewCell else {return}
            SafariVC.URL = URL(string: cell.textLabel!.text!)
            SafariVC.title = cell.textLabel!.text!
            
        default: break
            
        }
        
        
        
    }
    //
    //    
    //    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    //       
    //        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    //        
    //    }
    //    
    
}

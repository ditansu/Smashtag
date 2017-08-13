//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//


//5. Если пользователь выбирает какой-то  hashtag  или  user  в таблице “ mentions ”, то вы должны куда-то “переехать” (segue), чтобы показать результаты поиска в Twitter этого  hashtag  или u  ser . Это должен быть поиск именно  hashtags  или users , а не просто строки с  именем   hashtag  или  user  (например, поиск “#stanford”, а не “stanford”).  View Controller , куда вы “переедите” (segue), должен работать точно также, как ваш главный  View Controller , показывающий твиты ( TweetTableViewController ).


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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tweetMentions![indexPath.section].mentions[indexPath.row] {
            
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
            
            if let imageCell = cell as? ImageMentionTableViewCell {
                if  imageCell.imageURL != url {
                    imageCell.imageURL = url
                }
            }
            return cell
            
        case .text(let text)  :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Textcell", for: indexPath)
            cell.textLabel?.text = text
            return cell
            
        }
    }
    
    var sectionHeaderHeight : CGFloat = 28.0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tweetMentions![indexPath.section].mentions[indexPath.row] {
            
        case .image(_, let aspectRatio):
            
            let tableWidth = tableView.frame.width
            let tableHeight = tableView.frame.height + tableView.bounds.minY
            sectionHeaderHeight = max(sectionHeaderHeight,tableView.headerView(forSection: indexPath.section)?.frame.height ?? 0.0 )
            
            return min(tableWidth / CGFloat(aspectRatio), tableHeight - sectionHeaderHeight)
            
            
        case .text(_):
            
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

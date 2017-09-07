//
//  RecentQueriesController.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 20.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class RecentQueriesController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var recentQueries = RecentQueries()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    fileprivate struct slaveMVC {
        static let SearchMVC = "LoadRecentQueries"
        static let MentionPopularityMVC = "MentionPopularityMVC"
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case slaveMVC.SearchMVC :
            guard let cell = sender as? UITableViewCell else { return }
            let text = cell.textLabel?.text ?? ""
            recentQueries.appendUnique(mention: text)
        case slaveMVC.MentionPopularityMVC :
            guard
                  let mentionPopularityVC = (segue.destination.contents as? MentionPopularityTableViewController),
                  let indexPath = (sender as? IndexPath),
                  let cell = self.tableView.cellForRow(at: indexPath)
            else {return}
            
            mentionPopularityVC.title = cell.textLabel?.text
            mentionPopularityVC.searchTerm = cell.textLabel?.text
        default:
            return
        }
        
        
    }



}

extension RecentQueriesController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print ("DEB2: recentQueries \(recentQueries.count)")
        return recentQueries.count
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentQueries", for: indexPath)
        cell.textLabel?.text = recentQueries[indexPath.row]
        return cell
    }

    
// Detail discolsure segue call
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: slaveMVC.MentionPopularityMVC, sender: indexPath)
    }
    
// Delete row at swipe

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let result = UITableViewRowAction(
                style: UITableViewRowActionStyle.normal,
                title: "удалить") { _ in
                    guard let cell = tableView.cellForRow(at: indexPath) else {return}
                    print("cell.textLabel!.text!: \(cell.textLabel!.text!)")
                    self.recentQueries.remove(cell.textLabel!.text!)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                }
        
        result.backgroundColor = UIColor.red
       
        
        return [result]
    }
    
    
    

}

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

    private struct slaveMVC {
        static let SearchMVC = "LoadRecentQueries"
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
        //case slaveMVC.someSlaveMVC :
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
  

}

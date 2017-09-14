//
//  MentionPopularityTVCExtension.swift
//  Smashtag
//
//  Created by di on 08.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import CoreData

extension MentionPopularityTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return  popularityManager.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return popularityManager.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return popularityManager.titleForHeader(in: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return popularityManager.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let result = popularityManager.sectionForSectionIndexTitle(title: title, at: index)
        print("DEB1: sectionForSectionIndexTitle: \(result)")
        return result
    }
}

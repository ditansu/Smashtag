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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        let result = fetchedResultsController?.sections?.count ?? 1
        
        print("DEB1: numberOfSections: \(result)")
        
        return  result
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var result = 0
        if  let sections = fetchedResultsController?.sections, sections.count > 0 {
            result = sections[section].numberOfObjects
        } else {
            result = 0
        }
        
        print("DEB1: numberOfRowsInSection: \(result)")
        
        return result
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        https://www.andrewcbancroft.com/2015/03/05/displaying-data-with-nsfetchedresultscontroller-and-swift/
        
        var result : String? = nil
        
        if  let sections = fetchedResultsController?.sections, sections.count > 0 {
            result = sections[section].name
        }
       
        print("DEB1: titleForHeaderInSection: \(String(describing: result))")
        return result
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let result = fetchedResultsController?.sectionIndexTitles
        print("DEB1: sectionIndexTitles: \(String(describing: result))")
        return result
    }
    
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let result = fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
        print("DEB1: sectionForSectionIndexTitle: \(result)")
        return result
    }
    
    
}

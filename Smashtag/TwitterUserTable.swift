//
//  TwitterUserTable.swift
//  Smashtag
//
//  Created by di on 11.09.17.
//  Copyright © 2017 ditansu. All rights reserved.
//


import UIKit
import CoreData
import Twitter

class TwitterUserTable: NSManagedObject {
    
    class func findOrCreateTwitterUser(matching twitterInfo : Twitter.User, in context : NSManagedObjectContext)throws -> TwitterUserTable
    {
        let request : NSFetchRequest<TwitterUserTable> = TwitterUserTable.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        
        do {
            let matches = try context.fetch(request)
            
            if matches.count > 0 {
                assert(matches.count == 1, "TwitterUserTable.findOrCreateTwitterUser -- database inconsistency" )
                return matches.first!
            }
            
        } catch {
            throw error
        }
        
        let twitterUser    = TwitterUserTable(context : context)
        twitterUser.handle = twitterInfo.screenName
        twitterUser.name   = twitterInfo.name
        return twitterUser
        
    }
    
    
    
}

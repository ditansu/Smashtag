//
//  MentionsModel.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation


typealias Title = String
typealias ImageMentions = [(url: URL, aspectRatio : Double)]
typealias TextMentions = [String]

enum TweetMentions {

    case image   (Title, ImageMentions)
    case hashtag (Title, TextMentions)
    case url     (Title, TextMentions)
    case user    (Title, TextMentions)

}

extension TweetMentions {

    var count : Int {
        
        switch self {
        case .image (_, let mentions):
            return mentions.count
        case .hashtag(_, let mentions), .url(_, let mentions), .user(_, let mentions):
            return mentions.count
        }
    
    }

    
    var title : String {
        
        switch self {
        case .image (let title, _):
            return title
        case .hashtag(let title, _), .url(let title, _), .user(let title, _):
            return title
        }
        
    }
    
    var userOrHashtag : [String]? {
       
        switch self {
        case .image, .url:
            return nil 
        case .hashtag(_, let mentions), .user(_, let mentions):
            return mentions
        }
        
    }
    
}



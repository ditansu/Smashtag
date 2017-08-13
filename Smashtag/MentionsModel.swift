//
//  MentionsModel.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation

struct TweetMentions  {
    
    enum Mention {
        case image((url: URL, aspectRatio : Double))
        case text(String)
    }
    
    var count : Int { return self.mentions.count }
    let title : String
    let mentions : [Mention]
    
    init(title : String, mentions : [Mention]) {
        self.title = title
        self.mentions = mentions
    }
}

extension TweetMentions : CustomStringConvertible {
    
    var description: String { return "" }
    
}









//var tweetMentions = [MentionContent] ()

//    struct TweetImage : CustomStringConvertible {
//        var url         : URL
//        var aspectRatio : Double
//
//        init(url : URL, aspectRatio : Double) {
//            self.url = url
//            self.aspectRatio = aspectRatio
//        }
//
//        var description: String {
//            return "image url:\(url), ratio:\(aspectRatio)"
//        }
//    }
//
//    var images : [TweetImage] = []
//    var users : [String] = []
//    var urls : [String] = []
//    var hashtags : [String] = []
//
//    var description: String {
//        return "TweetMentions: images [\(images)], users: \(users), urls: \(urls), hash:\(hashtags)"
//    }
//
//}

//extension TweetMentions {
//    var countMentionsSections : Int {
//        var result : Int = 0
//        
//        if !images.isEmpty      { result+=1 }
//        if !users.isEmpty       { result+=1 }
//        if !urls.isEmpty        { result+=1 }
//        if !hashtags.isEmpty    { result+=1 }
//        
//        return result
//    }
//}

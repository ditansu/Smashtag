//
//  MentionsModel.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation





struct TweetMentions : CustomStringConvertible {
    
    struct TweetImage : CustomStringConvertible {
        var url         : String
        var aspectRatio : Double
        func init(url : String, aspectRatio : Double) {
            self.url = url
            self.aspectRatio = aspectRatio
        }
        
        var description: String {
            return "image url:\(url), ratio:\(aspectRatio)"
        }
    }
    
    var images : [TweetImage] = []
    var users : [String] = []
    var urls : [String] = []
    var hashtags : [String] = []
    
    var description: String {
        return "TweetMentions: images [\(images)], users: \(users), urls: \(urls), hash:\(hashtags)"
    }
    
}

extension TweetMentions {
    var countMentionsSections : Int {
        var result : Int = 0

        if !images.isEmpty      { result+=1 }
        if !users.isEmpty       { result+=1 }
        if !urls.isEmpty        { result+=1 }
        if !hashtags.isEmpty    { result+=1 }
        
        return result
    }
}

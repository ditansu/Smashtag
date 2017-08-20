//
//  MentionsModel.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation


enum MentionType {
    case image
    case hashtag
    case url
    case userinfo
}


struct TweetMentions  {
    
    enum Mention {
        case image((url: URL, aspectRatio : Double))
        case text(String)
    }
    
    var count : Int { return self.mentions.count }
    let title : String
    let mentions : [Mention]
    let type : MentionType
    
    init(title : String, type : MentionType,  mentions : [Mention]) {
        self.title = title
        self.mentions = mentions
        self.type = type
    }
}

extension TweetMentions : CustomStringConvertible {
    
    var description: String { return "" }
    
}


typealias Title = String
typealias ImageMentions = [(url: URL, aspectRatio : Double)]
typealias TextMentions = [String]

enum TweetMentions2 {

    case image   (Title, ImageMentions)
    case hashtag (Title, TextMentions)
    case url     (Title, TextMentions)
    case user    (Title, TextMentions)

}

extension TweetMentions2 {

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

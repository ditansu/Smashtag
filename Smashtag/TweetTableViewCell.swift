//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Dmitry Podoprosvetov on 01.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet : Twitter.Tweet? { didSet { updateUI()} }
    //for task # 1
    var tweetMentionsAttributes : [String : [String:Any] ] =
        [
    
        "user"      : [NSForegroundColorAttributeName : UIColor.green,
                       NSUnderlineStyleAttributeName  : NSUnderlineStyle.styleSingle.rawValue ],
        "hashtag"   : [NSForegroundColorAttributeName : UIColor.red],
        "url"       : [NSForegroundColorAttributeName : UIColor.blue,
                       NSUnderlineStyleAttributeName  : NSUnderlineStyle.styleSingle.rawValue ]
        ]
    
    private func updateUI(){
        
        
        let tweetText = NSMutableAttributedString(string: tweet?.text ?? "")
        
        tweetText.addAttributesForRanges(tweetMentionsAttributes["user"]!, ranges: tweet?.usersMentionsRanges)
        tweetText.addAttributesForRanges(tweetMentionsAttributes["hashtag"]!, ranges: tweet?.hashtagsMentionsRanges)
        tweetText.addAttributesForRanges(tweetMentionsAttributes["url"]!, ranges: tweet?.urlsMentionsRanges)
        
        tweetTextLabel?.attributedText = tweetText
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImgageURL = tweet?.user.profileImageURL {
            // FIXME: block main thread
            DispatchQueue.global(qos: .userInitiated).async{
                if let imageData = try? Data(contentsOf: profileImgageURL) {
                    DispatchQueue.main.async { [weak self] in
                        self!.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                    
                }
            }
            
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
        
    }
}



extension Tweet {

   private func mentionsToNSRangesArray(mentions : [Twitter.Mention]) -> [NSRange]? {
        var result : [NSRange]? = []
        for mention in mentions {
            result?.append(mention.nsrange)
        }
        return result
    }
    
    var usersMentionsRanges : [NSRange]? { get { return mentionsToNSRangesArray(mentions: self.userMentions) } }
    var hashtagsMentionsRanges : [NSRange]? { get { return mentionsToNSRangesArray(mentions: self.hashtags) } }
    var urlsMentionsRanges : [NSRange]? { get { return mentionsToNSRangesArray(mentions: self.urls) } }

}

extension NSMutableAttributedString {
    
    func addAttributesForRanges(_ attrs: [String : Any] = [:], ranges: [NSRange]?) {
        guard let rangeArray = ranges else {return}
        for range in rangeArray { self.addAttributes(attrs, range: range)  }
    }

}


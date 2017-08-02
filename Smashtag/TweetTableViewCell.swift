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
    
    var tweetMentionsAttributes : [String: [String:Any]]?
    
    private func updateUI(){
        
        //temp
        
        let attrStr : [String:Any] = [NSForegroundColorAttributeName : UIColor.blue]
        
        let tweetText = NSMutableAttributedString(string: tweet?.text ?? "")
        
        //tweetText.beginEditing()
        
        if let userMentions = tweet?.userMentions {
            for mention in userMentions {
                tweetText.addAttributes(attrStr, range: mention.nsrange)
            }
        }
        
       // tweetText.endEditing()
        
        //tweet?.userMentions
        //print(tweet?.userMentions)
        
        tweetTextLabel?.attributedText = tweetText
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImgageURL = tweet?.user.profileImageURL {
            // FIXME: block main thread
            if let imageData = try? Data(contentsOf: profileImgageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
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

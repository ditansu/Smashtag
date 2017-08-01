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

    private func updateUI(){
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImgageURL = tweet?.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImgageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            
        }
        
    }
}

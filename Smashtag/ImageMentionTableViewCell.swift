//
//  ImageMentionTableViewCell.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class ImageMentionTableViewCell: UITableViewCell {
    
    
    var imageURL : URL? { didSet{ updaeUI() } }
    
    @IBOutlet weak var imageMentionView: UIImageView!
    
    func resetSize() {
        imageMentionView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    private func updaeUI(){
        
        guard imageURL != nil else {return}
        
        let curretImageURL = imageURL!
        
        DispatchQueue.global(qos: .userInitiated).async{
            if let imageData = try? Data(contentsOf: curretImageURL) {
                DispatchQueue.main.async { [weak self] in
                    //check a situation after dreams
                    guard curretImageURL == self!.imageURL else { return }
                    
                    // set image
                    self!.imageMentionView.image = UIImage(data: imageData)
                    //set size!!! 
                    self!.imageMentionView.frame.size = CGSize(width: self!.frame.width, height: self!.frame.height)
                }
                
            }
        }
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

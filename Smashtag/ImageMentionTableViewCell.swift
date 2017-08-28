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
    
    private func updaeUI(){
        
        guard imageURL != nil else {return}
        
        let curretImageURL = imageURL!
        
        DispatchQueue.global(qos: .userInitiated).async{
            if let imageData = try? Data(contentsOf: curretImageURL) {
                DispatchQueue.main.async { [weak self] in
                    //check a situation after dreams ;
                    guard let url = self!.imageURL, url == curretImageURL else { return }
                    self!.imageMentionView.image = UIImage(data: imageData)
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

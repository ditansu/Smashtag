//
//  ImageViewCell.swift
//  Smashtag
//
//  Created by di on 23.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
 
    
    @IBOutlet var imageView: UIImageView!
  
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var imageURL : URL? { didSet{ updaeUI() } }
    
    var saveToCache : (( URL, UIImage, Int )->())?
 
    private func updaeUI(){
        
        guard imageURL != nil else {return}
        
        let curretImageURL = imageURL!
        self.startLoad()
       
        URLSession.shared.dataTask(with: curretImageURL){ data, response, error in
            
            if error != nil {
                print("URLSession ERROR: \(error!)")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                //check a situation after dreams ;
                self!.stopLoad()
                guard let url = self!.imageURL, url == curretImageURL else { return }
                self!.imageView.image = UIImage(data: data!)
                if let toCache = self!.saveToCache {
                    toCache(url,self!.imageView.image!, data!.count)
                }
                //self!.stopLoad()
            }
            
            
            }.resume()
        
    }

    

    
    func startLoad() {
        spinner.startAnimating()
    }
 
    func stopLoad() {
        spinner.stopAnimating()
    }
    
}

//
//  ImagesViewModel.swift
//  Smashtag
//
//  Created by di on 23.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation
import UIKit
import Twitter


typealias Images = [(tweet: Twitter.Tweet, url: URL, aspectRatio : Double)]


//struct ImagesByURLs {
//
//    //MARK: public API
//    var imagesURL = [(url: URL, aspectRatio : Double)]() {
//    
//        didSet{
//            update()
//        
//        }
//    
//    }
//    
//    //MARK - Private
//    
//    fileprivate var _images = [UIImage]()
//    
//    fileprivate let imageCache = NSCache<NSString,UIImage>()
//    
//    
//    mutating private func update(){
//        
//        
//        
//    }
//    
//
//}
//
//
//extension ImagesByURLs {
//
//    
//    subscript(index : Int) -> UIImage? {
//    
//        get {
//            
//            guard let url = imagesURL[index].url.absoluteString as? NSString else {return nil}
//            
//            return imageCache.object(forKey: url)
//        }
//    
//    }
//
//    
//
//}

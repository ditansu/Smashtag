//
//  ImageShowControl.swift
//  Smashtag
//
//  Created by di on 15.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class ImageShowControl: UIViewController {

    @IBOutlet var imageView: UIImageView! {
        didSet{
            imageView.image = image
            imageShow?.contentSize = imageView.frame.size
        }
    
    }
    
    @IBOutlet var imageShow: UIScrollView! {
    
        didSet {
            imageShow.delegate = self
            imageShow.maximumZoomScale = 2.0
            imageShow.minimumZoomScale = 0.03
            
        }
    
    }
    
    //MARK: - Model
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
    }
    
}

extension ImageShowControl : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    

    
}




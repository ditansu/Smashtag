//
//  ImagesViewController.swift
//  Smashtag
//
//  Created by di on 23.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"


class ImagesViewController: UICollectionViewController {

    //private let imagesCache = NSCache<URL,UImage>()
    
    
    // Model 
    
    var images = Images()
    let cacheImage = NSCache<NSString,AnyObject>()
    
    
    
    fileprivate let sectionInserts = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var itemsPerRow : CGFloat = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cacheImage.delegate = self
//        cacheImage.countLimit = 10
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let pinchHandler = #selector(self.changeScale(byReactionTo:))
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
        self.collectionView?.addGestureRecognizer(pinchRecognizer)

        let tapHandler   = #selector(self.setDefaultScale(byReactionTo:))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
        tapRecognizer.numberOfTapsRequired = 2
        self.collectionView?.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    // MARK: - Gesture handler 
    
    func changeScale(byReactionTo pinchRecognizer: UIPinchGestureRecognizer) {
    
        switch pinchRecognizer.state {
        case .changed, .ended:
            itemsPerRow *= pinchRecognizer.scale
            pinchRecognizer.scale = 1.0
            self.collectionView?.reloadData()
        default:
            break
        }
    
    }
    
    func setDefaultScale(byReactionTo pinchRecognizer: UITapGestureRecognizer) {
        itemsPerRow = 2.0
        self.collectionView?.reloadData()
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tweetFindVC  = self.tabBarController?.viewControllers?[0].contents as? TweetTableViewController
            else {return}
        
        self.navigationItem.title = tweetFindVC.searchText
        images = tweetFindVC.tweetImages
        self.collectionView?.reloadData()
        //print ("DEB1: images load: [\(images)]")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        images = Images()
        //print ("DEB1: images deleted: [\(images)]")
    }

    
    // MARK: - Navigation

    private struct slaveMVC {
        static let MentionMVC2 = "MentionMVC2"
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case slaveMVC.MentionMVC2 :
            
            guard let mentionVC = (segue.destination.contents as? MentionsTableViewController),
                let cell = sender as?  ImageViewCell,
                let indexPath = self.collectionView?.indexPath(for: cell) else { return }
           
            let tweet = images[indexPath.row].tweet
            mentionVC.tweetMentions = tweet.tweetMentions //prepareTweetMentions(tweet: tweet)
            mentionVC.title = tweet.user.screenName
            
        //case slaveMVC.someSlaveMVC :
        default:
            return
        }
        
        
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let imageCell = cell as? ImageViewCell, !images.isEmpty {
            // Configure the cell
            
            let url = images[indexPath.row].url
            
            if let cachedImage = cacheImage.object(forKey: url.absoluteString as NSString) as? UIImage {
                imageCell.imageView.image = cachedImage
                //print("DEB2: load from cashe: \(url)")
                return cell
            }
            
            if imageCell.imageURL != url {
                imageCell.saveToCache = saveImageToCache(url:image:cost:)
                imageCell.imageURL = url
            }
            

            
        }
        return cell
    }

    func saveImageToCache(url : URL, image : UIImage, cost : Int ) {
        
        // for gebug image.accessibilityIdentifier = url.absoluteString
        cacheImage.setObject(image, forKey: url.absoluteString as NSString, cost: cost)
        
        //print("DEB2: save to cashe: \(url) with cost: \(cost)")
    }
    
    // MARK: UICollectionViewDelegate

    
    
    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}



//extension ImagesViewController : NSCacheDelegate {
//
//
//    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
//        
//        print("DEB3:  delegate methode was began")
//       
//        guard let imgage = obj as? UIImage  else {return}
//    
//       print("DEB3: Will evict: \(String(describing: imgage.accessibilityIdentifier))")
//    }
//
//}



extension ImagesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let avaliableWidth = view.frame.width - paddingSpace
        let widthPerItem =  avaliableWidth / itemsPerRow
        let ratio = CGFloat(images[indexPath.row].aspectRatio)
        let heightPerItem =   widthPerItem / ratio
    
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}


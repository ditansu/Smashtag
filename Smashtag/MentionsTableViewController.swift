//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//


/*
 
 18. Вам точно понадобятся два различных  UITableViewCell  прототипа на вашей storyboard. Дайте им различные идентификаторы  identifiers  и  dequeue  в соответствующем прототипе в методе  cellForRowAt .
 19. Высота строки в вашем новом Controller не нуждается в “оценочной” высоте строки как в Controller “списка твитов”, потому что у вас очень мало строк и производительность не играет здесь решающего значения. Следовательно, вам захочется реализовать метод  heightForRowAt  делегата  UITableViewDelegate.
 20. Для строк, содержащих изображение (  image ), вам придется рассчитать подходящую высоту на основе их  aspect ratio . Для других строк высоту можно рассчитывать автоматически путем возврата  UITableViewAutomaticDimension из метода  heightForRowAt .
 21. Вы можете рассчитать соотношение сторон ( aspect   ratio ) изображения ( image ) в твите, не прибегая к реальной выборки  image  из своего  url . Смотри класс MediaItem  в поставляемом фреймворке  Twitter .
 
 */

import UIKit

class MentionsTableViewController: UITableViewController {

    // MODEL: - Tweet mentions model
    
    var tweetMentions : [TweetMentions]? {
        didSet {
           //  print(tweetMentions ?? "no mentions") // DEBUG: - check
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {        
        return  tweetMentions?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tweetMentions![section] {
        case .image(_ , let images):     return images.count
        case .mentions(_ ,let mentions): return mentions.count
        }
    
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch tweetMentions![section] {
        case .image(let title, _):      return title
        case .mentions(let title, _):   return title
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        switch tweetMentions![indexPath.section] {
        case .image(_, let images):
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
            
            if let imageCell = cell as? ImageMentionTableViewCell {
                if imageCell.imageURL != images[indexPath.row].url {
                    imageCell.imageURL = images[indexPath.row].url
                } else {
                    imageCell.resetSize()
                }
                    
            }
            
            return cell
            
        case .mentions(_, let mentions):

            let cell = tableView.dequeueReusableCell(withIdentifier: "Textcell", for: indexPath)
            cell.textLabel?.text = mentions[indexPath.row]
            return cell
      
        }
}
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tweetMentions![indexPath.section] {
        case .image(_, let images):
            let tableWidth = tableView.frame.width
            let tableHight = tableView.frame.height
            let ratio = CGFloat(images[indexPath.row].aspectRatio)
            
            var result = tableWidth / ratio
            
            if tableWidth > tableHight { result = tableWidth / ratio  } // tableHight / ratio
            
            return result
        case .mentions(_, _): return UITableViewAutomaticDimension
        }
    
    }

    
    //override func view
    
    private var oldView : CGFloat = 0.0
    
    private func rotateHandler() {
        
        let width = self.view.bounds.size.width
        
        if width != oldView {
            tableView.reloadData()
        }
        
        oldView = width
    
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rotateHandler()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        rotateHandler()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MentionsModel.swift
//  Smashtag
//
//  Created by di on 03.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation



//FIX IT!!! 
/*
 10. У вашего нового MVC с “ mentions ” (и  images ) в каждой секции элементы различного типа. Хотя у вас может быть искушение обращаться с ними при помощи длинных  if-then  или  switch  предложений в  UITableViewDataSource  и навигационных методах, более понятный подход заключался бы в создании внутренней структуры данных для вашей  UITableViewController , которая инкапсулирует данные в секциях (их сходство и различие). Например, было бы замечательно, если бы  numberOfSectionsInTableView , numberOfRowsInSection  и  titleForHeaderInSection  состояли бы из одной строки.
 11. Фактически, любой метод, который имеет больше дюжины (12) строк кода может быть плохо читабельным ( и иметь неудовлетворительный архитектурный подход).
 12. Не забывайте о таких возможностях  Swift  как  enum . Используйте S  wift  на полную возможность. Используйте структуры данных, которые мы создали для CalculatorBrain . Это может дать некоторое вдохновение для этого Задания.
*/

//struct TweetMentions : CustomStringConvertible {


//typealias ImageMentions = [(url: URL, aspectRatio : Double)]
//typealias TextMentions = [String]
//typealias Title = String
//
//
//enum TweetMentions  {
//    case image    (Title,ImageMentions)
//    case mentions (Title,TextMentions)
//}
//
//
//
//extension TweetMentions : CustomStringConvertible {
//
//    var description: String {
//        switch self {
//        case .image(let title, let imageMentions):
//            return "\(title) : \(imageMentions)"
//        case .mentions(let title, let textMentions):
//            return "\(title) :\(textMentions)"
//        }
//    }
//}
//

enum MentionType {
    case image
    case text
}

enum Mention {
    case image((url: URL, aspectRatio : Double))
    case text(String)
}

protocol TweetMention {
    
}

struct Mentions  {
    var count : Int { return self.mentions.count }
    let title : String
    let type  : MentionType
    let mentions : [Mention]
}

extension Mentions : CustomStringConvertible {
    
    var description: String { return "" }
    
}









//var tweetMentions = [MentionContent] ()

//    struct TweetImage : CustomStringConvertible {
//        var url         : URL
//        var aspectRatio : Double
//
//        init(url : URL, aspectRatio : Double) {
//            self.url = url
//            self.aspectRatio = aspectRatio
//        }
//
//        var description: String {
//            return "image url:\(url), ratio:\(aspectRatio)"
//        }
//    }
//
//    var images : [TweetImage] = []
//    var users : [String] = []
//    var urls : [String] = []
//    var hashtags : [String] = []
//
//    var description: String {
//        return "TweetMentions: images [\(images)], users: \(users), urls: \(urls), hash:\(hashtags)"
//    }
//
//}

//extension TweetMentions {
//    var countMentionsSections : Int {
//        var result : Int = 0
//        
//        if !images.isEmpty      { result+=1 }
//        if !users.isEmpty       { result+=1 }
//        if !urls.isEmpty        { result+=1 }
//        if !hashtags.isEmpty    { result+=1 }
//        
//        return result
//    }
//}

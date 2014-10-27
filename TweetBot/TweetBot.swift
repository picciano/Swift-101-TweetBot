//
//  TweetBot.swift
//  TweetBot
//
//  Created by Anthony Picciano on 10/27/14.
//  Copyright (c) 2014 Crispin Porter + Bogusky. All rights reserved.
//

import Foundation

class TweetBot {
    let twitter:STTwitterAPI
    
    init() {
        println("TweetBot init")

        twitter = STTwitterAPI(OAuthConsumerName: "TweetBot", consumerKey: "ouNnS1uDnpUSVWw5RzbdNTVfJ", consumerSecret: "XBxOnCS5UyIUOLHPTIksI8K7d5Q541TNKtXcLvuQHyJ1zXeQU6", oauthToken: "229526057-er0UY6VDZ8T8dYzOceXlKHGN4VV5zhqonPiKWwHn", oauthTokenSecret: "1gIXPfdw8MVQ6n78k8fLaPYfonrQ5kHyGVoGdQN1j4Ukd")
        
        twitter.verifyCredentialsWithSuccessBlock(successHandler, errorBlock: errorHandler)
    }
    
    func successHandler(username: String!) {
        println("Logged in as \(username)")
        
        twitter.postStatusesFilterKeyword("#swift101", progressBlock: progressHandler, errorBlock: errorHandler)
    }
    
    func errorHandler(error: NSError!) {
        println("Error: \(error)")
    }
    
    func progressHandler(response: [NSObject:AnyObject]!) {
        let dict = response as Dictionary
//        println("dict: \(dict)")
        
        if let id_str = dict["id_str"] as? String {
            let text = dict["text"] as String
            let user = dict["user"] as NSDictionary
            let screen_name = user["screen_name"] as String
            println("ID: \(id_str) name: \(screen_name) message: \(text)")
            
            postReply(id_str, originalAuthor: screen_name)
        }
    }
    
    func postReply(id_str: String, originalAuthor: String) {
        let responseText = "wow, @\(originalAuthor), sounds interesting \(NSDate())"
        println("replying...\(responseText)")
        
        twitter.postStatusUpdate(responseText, inReplyToStatusID: id_str, latitude: nil, longitude: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, successBlock: { (result) -> Void in
            println("result: \(result)")
        }) { (error) -> Void in
            println("error: \(error)")
        }
    }
}
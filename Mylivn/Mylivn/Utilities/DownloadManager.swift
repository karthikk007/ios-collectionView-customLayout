//
//  DownloadManager.swift
//  Mylivn
//
//  Created by Karthik Kumar on 27/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit

// MARK: - DownloadManager class, has cache to look up
class DownloadManager {
    
    // MARK: - member variables
    var imageCache = NSCache<NSString, UIImage>()
    var brokenLinks = Set<String>()
    
    static let shared = DownloadManager()
    
    // MARK: - life cycle
    private init() {

    }

    // MARK: - loadImage - lookup, load and cache
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void ) {
        
        if let image = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            completion(image)
        } else if brokenLinks.contains(url.absoluteString) {
            completion(nil)
        } else {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(nil)
                    
                    if let err = error as NSError? {
                        switch err.code {
                        case NSURLErrorUnsupportedURL, NSURLErrorCannotFindHost, NSURLErrorBadURL, NSURLErrorTimedOut:
                            self.brokenLinks.insert(url.absoluteString)
                        default:
                            break
                        }
                    }
                    
                    return
                }
                
                if let image = UIImage(data: data!) {
                    self.imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
                    completion(image)
                } else {
                    completion(nil)
                }
            }).resume()
        }
    }
}


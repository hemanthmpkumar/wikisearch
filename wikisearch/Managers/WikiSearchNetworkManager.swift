//
//  WikiSearchNetworkManager.swift
//  wikisearch
//
//  Created by Kumar m p, Hemanth - Hemanth on 7/22/18.
//  Copyright © 2018 Kumar m p, Hemanth - Hemanth. All rights reserved.
//

import UIKit

import Foundation

enum API {
    
    static func UrlFor(searchString: String) -> URL {
        let urlStr = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=\(searchString)&gpslimit=10".addingPercentEncoding(withAllowedCharacters:  CharacterSet.urlQueryAllowed) ?? ""
        
        return  URL(string: urlStr)!
    }
    
    static func webURLFor(item: String) -> URL {
        let urlStr = "https://en.wikipedia.org/wiki/\(item)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        return  URL(string: urlStr)!
    }
    
    static let baseURL = URL(string: "https://en.wikipedia.org/wiki/")!
}

class WikiSearchNetworkManager: NSObject {
    // MARK: - Properties
    private static var sharedNetworkManager: WikiSearchNetworkManager = {
        let networkManager = WikiSearchNetworkManager(baseURL: API.baseURL)
        
        // Configuration
        return networkManager
    }()
    
    // MARK: -
    let baseURL: URL
    
    // Initialization
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Accessors
    class func shared() -> WikiSearchNetworkManager {
        return sharedNetworkManager
    }
}

extension WikiSearchNetworkManager {
    func performeSearch(on searchKey: String, onCompletion completion:@escaping (Bool, Any?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: API.UrlFor(searchString: searchKey)){ (data, response, error) in
            if error != nil {
                completion(false, nil, error)
            } else {
                if let usableData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: usableData, options: [])
                        completion(true, json, nil)
                    } catch let error {
                         completion(false, nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}

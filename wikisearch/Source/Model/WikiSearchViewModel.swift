//
//  WikiSearchViewModel.swift
//  wikisearch
//
//  Created by Kumar m p, Hemanth - Hemanth on 7/22/18.
//  Copyright © 2018 Kumar m p, Hemanth - Hemanth. All rights reserved.
//

import UIKit

struct AppJSONKeys {
    static let query = "query"
    static let pages = "pages"
    static let pageid = "pageid"
    static let title = "title"
    static let thumbnail = "thumbnail"
    static let terms = "terms"
    static let description = "description"
}

protocol SearchTerm {
    var title: String {get set}
}

struct SearchResult: SearchTerm {
    let pageid: Int
    var title: String
    let imageUrl: String
    let description: String
    
    static func parse(from jsonDict: [String: AnyObject]) -> SearchResult? {
        guard let pageId = jsonDict[AppJSONKeys.pageid] as? Int else {
            return nil
        }
        let title = (jsonDict[AppJSONKeys.title] as? String) ?? ""
        let thumbnail = (jsonDict[AppJSONKeys.thumbnail] as? String) ?? ""
        
        var description = ""
        if let terms = jsonDict[AppJSONKeys.terms] as? [String: AnyObject],
        let descriptionsList =  terms[AppJSONKeys.description] as? [String],
            let itemDesc = descriptionsList.first {
            description = itemDesc
        }
        return SearchResult(pageid: pageId, title: title, imageUrl: thumbnail, description: description)
    }
    
    static func parse(from jsonDictArray: [[String: AnyObject]]) -> [SearchResult] {
        var searchResults = [SearchResult]()
        for item in jsonDictArray {
            if let searchResult = SearchResult.parse(from: item) {
                searchResults.append(searchResult)
            }
        }
        return searchResults
    }
    
}

struct RecentSearchItem: SearchTerm {
    var title: String
}

class WikiSearchViewModel {

    var searchItems: [SearchResult] = []
    var recentItems:[RecentSearchItem] = []
    var searchTerm = ""
    
    func getNumberOfItems(isSearchActive: Bool) -> Int {
        return isSearchActive ? filteredResult().count : searchItems.count
    }
    
    func getItemForIndexpath(indexpath: IndexPath, isSearchActive: Bool) -> SearchTerm {
        return isSearchActive ? filteredResult()[indexpath.row] : searchItems[indexpath.row]
    }
    
    func filteredResult() -> [RecentSearchItem] {
        if searchTerm.isEmpty {
            return recentItems
        } else {
            let filtered = recentItems.filter { (item) -> Bool in
                let tmp: NSString = item.title as NSString
                let range = tmp.range(of: searchTerm, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }
            return filtered
        }
    }
}

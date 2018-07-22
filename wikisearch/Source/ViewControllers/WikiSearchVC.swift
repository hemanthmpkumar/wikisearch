//
//  ViewController.swift
//  wikisearch
//
//  Created by Kumar m p, Hemanth - Hemanth on 7/21/18.
//  Copyright © 2018 Kumar m p, Hemanth - Hemanth. All rights reserved.
//

import UIKit
import PKHUD

class WikiSearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeView: UIView!
    
    var searchActive : Bool = false
    var viewmodel: WikiSearchViewModel = WikiSearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func handleSearch(_ sender: Any) {
        tableView.isHidden = false
        welcomeView.isHidden = true
        searchBar.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" , let destVC = segue.destination as? WikiSearchDetailPageVC, let indexpath = sender as? IndexPath {
            destVC.url = API.webURLFor(item: viewmodel.getItemForIndexpath(indexpath: indexpath, isSearchActive: searchActive).title)
        }
    }
}

extension WikiSearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.getNumberOfItems(isSearchActive: searchActive)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSuggestionTableViewCell") as! SearchSuggestionTableViewCell
            cell.confugure(with: viewmodel.getItemForIndexpath(indexpath: indexPath, isSearchActive: searchActive))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as! SearchResultTableViewCell
            cell.confugure(with: viewmodel.getItemForIndexpath(indexpath: indexPath, isSearchActive: searchActive))
            return cell
        }
    }
}

extension WikiSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searchActive {
            performSegue(withIdentifier: "showDetail", sender: indexPath)
        }
    }
}

extension WikiSearchVC: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true;
//    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        PKHUD.sharedHUD.show()
        WikiSearchNetworkManager.shared().performeSearch(on: searchBar.text ?? "") { (status, response, error) in
            if let jsonDict = response as? [String: AnyObject] ,
                let query  = jsonDict[AppJSONKeys.query] as? [String: AnyObject],
                let pages = query[AppJSONKeys.pages] as? [[String: AnyObject]] {
                let searchResults = SearchResult.parse(from: pages)
                DispatchQueue.main.async {
                    self.viewmodel.searchItems = searchResults
                    self.tableView.reloadData()
                    PKHUD.sharedHUD.hide()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    PKHUD.sharedHUD.hide()
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchActive = !searchText.isEmpty
        viewmodel.searchTerm = searchText
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text as NSString
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
        self.tableView.reloadData()
    }
}


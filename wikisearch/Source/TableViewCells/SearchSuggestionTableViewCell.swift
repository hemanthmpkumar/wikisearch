//
//  SearchSuggestionTableViewCell.swift
//  wikisearch
//
//  Created by Kumar m p, Hemanth - Hemanth on 7/21/18.
//  Copyright © 2018 Kumar m p, Hemanth - Hemanth. All rights reserved.
//

import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var searchItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func confugure(with searchResult: SearchTerm) {
        guard let searchResult = searchResult as? RecentSearchItem  else {
            return
        }
        self.searchItemLabel.text = searchResult.title
    }
}

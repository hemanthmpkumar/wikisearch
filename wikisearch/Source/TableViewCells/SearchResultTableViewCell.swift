//
//  SearchResultTableViewCell.swift
//  wikisearch
//
//  Created by Kumar m p, Hemanth - Hemanth on 7/21/18.
//  Copyright © 2018 Kumar m p, Hemanth - Hemanth. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultTitleLable: UILabel!
    @IBOutlet weak var resultDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func confugure(with searchResult: SearchTerm) {
        guard let searchResult = searchResult as? SearchResult  else {
            return
        }
        self.resultTitleLable.text = searchResult.title
        self.resultDescription.text = searchResult.description
        //Load Image
    }

}

//
//  ItemsTableViewCell.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var cookBookTitle: UILabel!
    @IBOutlet weak var cookBookDetail: UILabel!
    @IBOutlet weak var lastMadeTitle: UILabel!
    @IBOutlet weak var lastMadeDate: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

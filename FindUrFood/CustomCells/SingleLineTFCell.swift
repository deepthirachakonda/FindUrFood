//
//  SingleLineTFCell.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class SingleLineTFCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var singleLineTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: singleLineTF.frame.height))
        singleLineTF.leftView = paddingView
        singleLineTF.leftViewMode = .always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

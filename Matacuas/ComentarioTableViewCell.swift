//
//  ComentarioTableViewCell.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 16/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class ComentarioTableViewCell: UITableViewCell {

    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var matriculaLabel: UILabel!
    @IBOutlet weak var comentarioLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        innerView.layer.cornerRadius = 15.0
        innerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        innerView.layer.borderWidth = 1
        innerView.layer.shadowColor = UIColor.blackColor().CGColor
        innerView.layer.shadowOpacity = 0.4
        innerView.layer.shadowRadius = 2.0
        innerView.layer.shadowOffset = CGSizeMake(0, 2.0)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

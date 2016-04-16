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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

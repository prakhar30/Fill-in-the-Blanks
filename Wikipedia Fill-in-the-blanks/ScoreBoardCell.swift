//
//  ScoreBoardCell.swift
//  Wikipedia Fill-in-the-blanks
//
//  Created by Prakhar Tripathi on 01/01/18.
//  Copyright © 2018 Prakhar Tripathi. All rights reserved.
//

import UIKit

class ScoreBoardCell: UITableViewCell {

    @IBOutlet weak var userGuessLabel: UILabel!
    @IBOutlet weak var rightAnswerLabel: UILabel!
    @IBOutlet weak var numberIndicatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

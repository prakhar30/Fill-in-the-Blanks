//
//  ScoreScreen.swift
//  Wikipedia Fill-in-the-blanks
//
//  Created by Prakhar Tripathi on 01/01/18.
//  Copyright © 2018 Prakhar Tripathi. All rights reserved.
//

import UIKit

class ScoreScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Your score is \(score) out of 10."
        score = 0
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScoreBoardCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ScoreBoardCell
        if(indexPath.row == 0){
            cell.numberIndicatorLabel.text = "No."
            cell.rightAnswerLabel.text = "Right Answer"
            cell.userGuessLabel.text = "Your Answer"
        }else{
            cell.numberIndicatorLabel.text = "\(indexPath.row - 1)"
            cell.rightAnswerLabel.text = correctAnswer[indexPath.row - 1]
            cell.userGuessLabel.text = userAnswer[indexPath.row - 1]
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

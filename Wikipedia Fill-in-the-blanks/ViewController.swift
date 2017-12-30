//
//  ViewController.swift
//  Wikipedia Fill-in-the-blanks
//
//  Created by Prakhar Tripathi on 29/12/17.
//  Copyright © 2017 Prakhar Tripathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var dataArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        
    }
    
    func generateLabel() -> UILabel{
        let lblNew = UILabel()
        lblNew.backgroundColor = UIColor.blue
        lblNew.text = "Test"
        lblNew.textColor = UIColor.white
        lblNew.translatesAutoresizingMaskIntoConstraints = false
        return lblNew
    }
    
    func getdata(){
        IJProgressView.shared.showProgressView(view)
        let url = URL(string: "\(baseURL)\(documents.randomElement()!)\(settingsURL)")
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                        var mainData = "\(json![2])"
                        mainData.remove(at: mainData.startIndex)
                        mainData.remove(at: mainData.index(before: mainData.endIndex))
//                        self.textView.text = "\(mainData)"
                        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse(recognizer:)))
                        tapGesture.numberOfTapsRequired = 1
                        self.textView.addGestureRecognizer(tapGesture)
                        self.stringToArray(data: mainData)
                        IJProgressView.shared.hideProgressView()
                    }
                }
            })
            task.resume()
        }
    }
    
    func tapResponse(recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: textView)
        let position: CGPoint = CGPoint(x: location.x, y: location.y)
        let tapPosition: UITextPosition = textView.closestPosition(to: position)!
        let textRange: UITextRange = textView.tokenizer.rangeEnclosingPosition(tapPosition, with: .word, inDirection: 1)!
        
        let tappedWord: String = textView.text(in: textRange)!
        print("\(tappedWord) \(tappedWord.characters.count)")
    }
    
    func stringToArray(data:String){
        dataArray = data.components(separatedBy: " ")
        for _ in 0..<4 {
            self.dataArray.remove(at: 0)
        }
        var text = ""
        for index in 0..<dataArray.count {
            text += "\(dataArray[index]) "
        }
        textView.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


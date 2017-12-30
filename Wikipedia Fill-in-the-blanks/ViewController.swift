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
    var hiddenWord = [String]()
    var hiddenWordLocation = [Int]()
    
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
                        self.stringToArray(data: mainData)
                        IJProgressView.shared.hideProgressView()
                    }
                }
            })
            task.resume()
        }
    }
    
    func stringToArray(data:String){
        dataArray = data.components(separatedBy: " ")
        for _ in 0..<4 {
            self.dataArray.remove(at: 0)
        }
        for i in 0..<4 {
            let randomIndex = Int(arc4random_uniform(UInt32(dataArray.count)))
            let randomWord = dataArray[randomIndex]
            hiddenWord.append(randomWord)
            hiddenWordLocation.append(randomIndex)
            dataArray[randomIndex] = "(___\(i)___)"
            var text = ""
            for index in 0..<dataArray.count {
                text += "\(dataArray[index]) "
            }
            textView.text = text
            
            let copyText = text as NSString
            let range = copyText.range(of: "(___\(i)___)", options: .literal, range: NSMakeRange(0, copyText.length))
            textView.layoutManager.ensureLayout(for: textView.textContainer)
            let start = textView.position(from: textView.beginningOfDocument, offset: range.location)!
            let end = textView.position(from: start, offset: range.length)!
            let tRange = textView.textRange(from: start, to: end)
            let rect = textView.firstRect(for: tRange!)
            
            let button = UIButton(frame: CGRect(x: rect.minX, y: rect.minY, width: 68, height: 20))
            button.backgroundColor = .clear
            button.setTitle("", for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.textView.addSubview(button)
        }


        print(hiddenWord)
        print(hiddenWordLocation)
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped \(sender.tag)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


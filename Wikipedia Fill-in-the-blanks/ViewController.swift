//
//  ViewController.swift
//  Wikipedia Fill-in-the-blanks
//
//  Created by Prakhar Tripathi on 29/12/17.
//  Copyright © 2017 Prakhar Tripathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    var inputData = ""
    var dataArray = [String]()
    var hiddenWord = [String]()
    var hiddenWordLocation = [Int]()
    var userGuess = ["", "", "", "", "", "", "", "", "", ""]
    var shuffledHiddenWords = ["", "", "", "", "", "", "", "", "", ""]
    var buttonPressed = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerClose))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        getdata()
    }
    
    func pickerClose(){
        pickerView.isHidden = true
    }
    
    @IBAction func finishGameButton(_ sender: Any) {
        print(userGuess)
        if (hiddenWord == userGuess){
            print("You win")
        }else{
            print("you chutiya")
        }
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
                        self.inputData = mainData
//                        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse(recognizer:)))
//                        tapGesture.numberOfTapsRequired = 1
//                        self.textView.addGestureRecognizer(tapGesture)
                        self.pickerView.reloadAllComponents()
                        IJProgressView.shared.hideProgressView()
                    }
                }
            })
            task.resume()
        }
    }
    
//    func tapResponse(recognizer: UITapGestureRecognizer) {
//        let location: CGPoint = recognizer.location(in: textView)
//        let position: CGPoint = CGPoint(x: location.x, y: location.y)
//        let tapPosition: UITextPosition = textView.closestPosition(to: position)!
//        print("tap at \(position.x) \(position.y)")
//        
//        if let textRange: UITextRange = textView.tokenizer.rangeEnclosingPosition(tapPosition, with: .word, inDirection: 1) {
//            let tappedWord: String = textView.text(in: textRange)!
//            print("\(tappedWord) \(tappedWord.characters.count)")
//        }
//    }
    
    func stringToArray(data:String){
        dataArray = data.components(separatedBy: " ")
        for i in 0..<dataArray.count{
            dataArray[i] = dataArray[i].trimmingCharacters(in: .illegalCharacters)
        }
        for _ in 0..<4 {
            self.dataArray.remove(at: 0)
        }
        for i in 0..<10 {
            var randomIndex = Int(arc4random_uniform(UInt32(dataArray.count)))
            var randomWord = dataArray[randomIndex]
            while(randomWord.characters.count < 10){
                randomIndex = Int(arc4random_uniform(UInt32(dataArray.count)))
                randomWord = dataArray[randomIndex]
            }
            hiddenWord.append(randomWord)
            hiddenWordLocation.append(randomIndex)
            dataArray[randomIndex] = "(___\(i)___)"
            var text = ""
            for index in 0..<dataArray.count {
                text += "\(dataArray[index]) "
            }
            textView.text = text
        }
        
        for i in 0..<10 {
            let copyText = textView.text as NSString
            let range = copyText.range(of: "(___\(i)___)", options: .literal, range: NSMakeRange(0, copyText.length))
            textView.layoutManager.ensureLayout(for: textView.textContainer)
            let start = textView.position(from: textView.beginningOfDocument, offset: range.location)!
            let end = textView.position(from: start, offset: range.length)!
            let tRange = textView.textRange(from: start, to: end)
            let rect = textView.firstRect(for: tRange!)
            
            let button = UIButton(frame: CGRect(x: rect.minX, y: rect.minY, width: 50, height: 20))
            button.backgroundColor = .green
            button.alpha = 0.5
            button.setTitle("", for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.textView.addSubview(button)
        }
        shuffledHiddenWords = shuffleArray(array: hiddenWord)
        print(hiddenWord)
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped \(sender.tag)")
        buttonPressed = sender.tag
        pickerView.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shuffledHiddenWords.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(shuffledHiddenWords[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userGuess[buttonPressed] = shuffledHiddenWords[row]
    }
    
    func shuffleArray(array: [String]) -> [String] {
        
        var tempArray = array
        for index in 0...array.count - 1 {
            let randomNumber = arc4random_uniform(UInt32(tempArray.count - 1))
            let randomIndex = Int(randomNumber)
            tempArray[randomIndex] = array[index]
        }
        
        return tempArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


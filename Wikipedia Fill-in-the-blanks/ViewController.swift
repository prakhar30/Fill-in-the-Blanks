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
    var buttons = [UIButton]()
    var userGuess = ["", "", "", "", "", "", "", "", "", ""]
    var shuffledHiddenWords = ["", "", "", "", "", "", "", "", "", ""]
    var previousSelectedWord = ["", "", "", "", "", "", "", "", "", ""]
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
        for i in 0..<10 {
            if(shuffledHiddenWords[i] == userGuess[i]){
                score += 1
            }
        }
        correctAnswer = shuffledHiddenWords
        userAnswer = userGuess
        performSegue(withIdentifier: "toScoreScreen", sender: self)
    }
    
    func getdata(){
        IJProgressView.shared.showProgressView(view)
        let url = URL(string: "\(baseURL)\(documents.randomElement()!)\(settingsURL)")
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    IJProgressView.shared.hideProgressView()
                    guard let data = data, error == nil else {              // check for fundamental networking error
                        self.alertBox(msg: "Network Error.")
                        return
                    }
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    var mainData = "\(json![2])"
                    mainData.remove(at: mainData.startIndex)
                    mainData.remove(at: mainData.index(before: mainData.endIndex))
                    self.stringToArray(data: mainData)
                    self.buttonOverText()
                    self.inputData = mainData
                    //                        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse(recognizer:)))
                    //                        tapGesture.numberOfTapsRequired = 1
                    //                        self.textView.addGestureRecognizer(tapGesture)
                    self.pickerView.reloadAllComponents()
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
    }
    
    func replaceSelectedWordIntext(){
        print("guessed word \(userGuess[buttonPressed])")
//        for i in 0..<dataArray.count{
//            if(dataArray[i] == "(___\(buttonPressed)___)" || (dataArray[i] == userGuess[buttonPressed] && i == hiddenWordLocation[buttonPressed])){
//                dataArray[i] = userGuess[buttonPressed]
//                break
//            }
//        }
        dataArray[hiddenWordLocation[buttonPressed]] = userGuess[buttonPressed]
        var text = ""
        for index in 0..<dataArray.count {
            text += "\(dataArray[index]) "
        }
        textView.text = text
        changeButtonLocationForReplacedWord(button: buttons[buttonPressed], onWord: userGuess[buttonPressed])
        changeButtonLocationForOtherWords(changedIndex: buttonPressed)
    }
    
    func buttonOverText(){
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
            buttons.append(button)
        }
        shuffledHiddenWords = hiddenWord
        //        shuffledHiddenWords = shuffleArray(array: hiddenWord)
        //        shuffledHiddenWords = shuffleArray(array: hiddenWord)
        print(hiddenWord)
    }
    
    func changeButtonLocationForReplacedWord(button:UIButton, onWord:String){
        let copyText = textView.text as NSString
        let range = copyText.range(of: onWord, options: .literal, range: NSMakeRange(0, copyText.length))
        textView.layoutManager.ensureLayout(for: textView.textContainer)
        let start = textView.position(from: textView.beginningOfDocument, offset: range.location)!
        let end = textView.position(from: start, offset: range.length)!
        let tRange = textView.textRange(from: start, to: end)
        let rect = textView.firstRect(for: tRange!)
        button.frame = CGRect(x: rect.minX, y: rect.minY, width: 50, height: 20)
    }
    
    func changeButtonLocationForOtherWords(changedIndex:Int){
        for i in 0..<10 {
            if(i != changedIndex){
                let copyText = textView.text as NSString
                let range = copyText.range(of: "(___\(i)___)", options: .literal, range: NSMakeRange(0, copyText.length))
                textView.layoutManager.ensureLayout(for: textView.textContainer)
                if (range.location < 50000){
                    let start = textView.position(from: textView.beginningOfDocument, offset: range.location)!
                    let end = textView.position(from: start, offset: range.length)!
                    let tRange = textView.textRange(from: start, to: end)
                    let rect = textView.firstRect(for: tRange!)
                    buttons[i].frame = CGRect(x: rect.minX, y: rect.minY, width: 50, height: 20)
                }

            }
        }
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
        replaceSelectedWordIntext()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("orientation changed")
    }
    
    func reactToOrientationChange(){
        for i in 0..<10 {
            let copyText = textView.text as NSString
            let range = copyText.range(of: "(___\(i)___)", options: .literal, range: NSMakeRange(0, copyText.length))
            textView.layoutManager.ensureLayout(for: textView.textContainer)
            let start = textView.position(from: textView.beginningOfDocument, offset: range.location)!
            let end = textView.position(from: start, offset: range.length)!
            let tRange = textView.textRange(from: start, to: end)
            let rect = textView.firstRect(for: tRange!)
            
            buttons[i].frame = CGRect(x: rect.minX, y: rect.minY, width: 50, height: 20)
        }
    }
    
    func alertBox(msg: String) {
        let refreshAlert = UIAlertController(title: "Error", message: "\(msg)", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


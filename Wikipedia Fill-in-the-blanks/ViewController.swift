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
    var dataArray = [String]()
    var hiddenWord = [String]()
    var hiddenWordLocation = [Int]()
    
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
                        self.pickerView.reloadAllComponents()
                        IJProgressView.shared.hideProgressView()
                    }
                }
            })
            task.resume()
        }
    }
    
    func stringToArray(data:String){
        dataArray = data.components(separatedBy: " ")
        for i in 0..<dataArray.count{
            dataArray[i] = dataArray[i].trimmingCharacters(in: .illegalCharacters)
        }
        for _ in 0..<4 {
            self.dataArray.remove(at: 0)
        }
        for i in 0..<4 {
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
            
            let copyText = text as NSString
            let range = copyText.range(of: "(___\(i)___)", options: .literal, range: NSMakeRange(0, copyText.length))
            textView.layoutManager.ensureLayout(for: textView.textContainer)
            let start = textView.position(from: textView.beginningOfDocument, offset: range.location)!
            let end = textView.position(from: start, offset: range.length)!
            let tRange = textView.textRange(from: start, to: end)
            let rect = textView.firstRect(for: tRange!)
            
            let button = UIButton(frame: CGRect(x: rect.minX - 20, y: rect.minY - 20, width: 88, height: 40))
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
        pickerView.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hiddenWord.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(hiddenWord[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(hiddenWord[row])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


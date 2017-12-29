//
//  ViewController.swift
//  Wikipedia Fill-in-the-blanks
//
//  Created by Prakhar Tripathi on 29/12/17.
//  Copyright © 2017 Prakhar Tripathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
    }
    
    func getdata(){
        let url = URL(string: "\(baseURL)\(documents.randomElement()!)\(settingsURL)")
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    print(json![2])
                }
            })
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


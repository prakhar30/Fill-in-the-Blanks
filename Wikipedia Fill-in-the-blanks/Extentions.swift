//
//  Extentions.swift
//  Wikipedia Fill-in-the-blanks
//
//  Created by Prakhar Tripathi on 29/12/17.
//  Copyright © 2017 Prakhar Tripathi. All rights reserved.
//

import Foundation

extension Collection where Index == Int {
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
}


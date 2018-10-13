//
//  StringExtension.swift
//  GOESP
//
//  Created by Olga Vyrostko on 13.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import Foundation

extension String {
    init(alph: [String], len: Int) {
        var str = [String]()
        for _ in 0..<len {
            let rand = Int(arc4random_uniform(UInt32(alph.count)))
            str.append(alph[rand])
        }
        self.init(str.joined())
    }
}

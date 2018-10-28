//
//  GOESPSearchTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 28/10/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

/**
 Problem: should move not from the beginning of
 first queue to its end, but using tree symbols
 */

final class GOESPSearchTestCase: XCTestCase {
    func testSearch2Mer() {
        print(grammar.searchDeep(substring: "CA"))
    }
}

private let grammar = GOESP.build(str: "AACAABAAA")

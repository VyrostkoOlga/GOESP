//
//  GOESPSearchTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 28/10/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class GOESPSearchTestCase: XCTestCase {
    func testSearch2Mer() {
        grammar.search(substring: "AA")
        grammar.search(substring: "ACA")
    }
}

private let grammar = GOESP.build(str: "AACACAAAC")

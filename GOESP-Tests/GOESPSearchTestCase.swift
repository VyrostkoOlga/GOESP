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
        XCTAssertEqual([0, 1, 4], grammar.searchDeep2(substring: "AA"))
        XCTAssertEqual([2], grammar.searchDeep2(substring: "AC"))
        XCTAssertEqual([5], grammar.searchDeep2(substring: "AB"))
        XCTAssertEqual([6], grammar.searchDeep2(substring: "BA"))

        XCTAssertEqual([0, 2, 5, 7, 9], grammar2.searchDeep2(substring: "CA"))
        
    }
}

private let grammar = GOESP.build(str: "AAACAABA")
private let grammar2 = GOESP.build(str: "CACABCACACA")

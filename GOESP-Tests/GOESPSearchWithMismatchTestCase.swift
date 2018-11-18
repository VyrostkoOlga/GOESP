//
//  GOESPSearchWithMismatchTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 17/11/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class GOESPSearchWithMismatchTestCase: XCTestCase {

    func testBaseSearch() {
        XCTAssertEqual([0, 5], grammar1.search(substring: "AA", nodeSelectHandler: nodeDidSelect))
        XCTAssertEqual([0, 1, 2, 3, 4, 5, 6, 7], grammar1.search(substring: "AA", distance: 1, nodeSelectHandler: nodeDidSelect))
        XCTAssertEqual([1, 3, 6], grammar1.search(substring: "ATA", distance: 1, nodeSelectHandler: nodeDidSelect))
        XCTAssertEqual([0, 1, 3, 4, 5, 6], grammar1.search(substring: "AAA", distance: 1, nodeSelectHandler: nodeDidSelect))
    }

    func testBaseSearch2() {
        XCTAssertEqual([0, 1], grammar2.search(substring: "AAA", distance: 1, nodeSelectHandler: nodeDidSelect))
    }

    func nodeDidSelect(level: Int, symbol: Int) {
        //print("Move to \(level), \(symbol)")
    }
}

private let grammar1 = GOESP.build(str: "AACACAATA")
private let grammar2 = GOESP.build(str: "AACAC")

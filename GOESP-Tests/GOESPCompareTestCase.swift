//
//  GOESPCompareTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 27/10/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

/**
 Problem 1:
 different nonterminals for letters, f.e.
 AACA and CACA, A = 0 != 1 = A
 mapAlph:
 alph1, alph2
 el = alph2[el]
 el = index of el in alph1

 Problem 2:
 splice patterns, f.e.
 AACA and CACA
 */

final class GOESPCompareTestCase: XCTestCase {

    func testCompareBasic() {
        let g1 = GOESP.build(str: "AACCCA")
        let g2 = GOESP.build(str: "AACACA")
        let diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([3]), Set([1, 2]), Set([0])], diff)
    }

    func testCompare4Mers() {
        let g1 = GOESP.build(str: "AACA")
        var g2 = GOESP.build(str: "ACCA")
        var diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([1]), Set([0]), Set([0])], g1.findLevelsDiffUp(other: g2))

        g2 = GOESP.build(str: "TACA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([0]), Set([0]), Set([0])], diff)

        g2 = GOESP.build(str: "TAAA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([0, 2]), Set([0, 1]), Set([0])], diff)
    }

}

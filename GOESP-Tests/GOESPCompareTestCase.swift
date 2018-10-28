//
//  GOESPCompareTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 27/10/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

/**
 Problem 1 - solved:
 different nonterminals for letters, f.e.
 AACA and CACA, A = 0 != 1 = A
 mapAlph:
 alph1, alph2
 el = alph2[el]
 el = index of el in alph1

 Problem 2 - solved:
 splice patterns, f.e.
 AACA and CACA
 */

final class GOESPCompareTestCase: XCTestCase {

    func testCompareBasic() {
        let g1 = GOESP.build(str: "AACCCA")
        let g2 = GOESP.build(str: "AACACA")
        let diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([3]), Set([1, 2]), Set([0])], diff)
        XCTAssertEqual([Set([3]), Set([1, 2]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)
    }

    func testCompare4Mers() {
        let g1 = GOESP.build(str: "AACA")
        var g2 = GOESP.build(str: "ACCA")
        var diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([1]), Set([0]), Set([0])], g1.findLevelsDiffUp(other: g2))
        XCTAssertEqual([Set([1]), Set([0]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        g2 = GOESP.build(str: "TACA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([0]), Set([0]), Set([0])], diff)
        XCTAssertEqual([Set([0]), Set([0]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        g2 = GOESP.build(str: "TAAA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([0, 2]), Set([0, 1]), Set([0])], diff)
        XCTAssertEqual([Set([0, 2]), Set([0, 1]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        g2 = GOESP.build(str: "CACA")
        diff = g1.findLevelsDiffUp(other: g2)
        // note - correct?
        XCTAssertEqual([Set([0]), Set([0, 1]), Set([0])], diff)
        XCTAssertEqual([Set([0]), Set([0, 1]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        // equal
        g2 = GOESP.build(str: "AACA")
        XCTAssertEqual([Set<Int>(), Set(), Set()], g1.findLevelsDiffUp(other: g2))
        XCTAssertEqual([Set<Int>(), Set(), Set()], g2.findLevelsDiffUp(other: g1))
        XCTAssertTrue(g1 == g2)
    }

    func testCompare6Mers() {
        let g1 = GOESP.build(str: "AACCCA")
        var g2 = GOESP.build(str: "ACCCCA")
        var diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([1]), Set([0]), Set([0])], diff)
        XCTAssertEqual([Set([1]), Set([0]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        g2 = GOESP.build(str: "CACCCA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([0]), Set([0, 2]), Set([0])], diff)
        XCTAssertEqual([Set([0]), Set([0, 2]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        g2 = GOESP.build(str: "CACACA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set([0]), Set([0, 1, 2]), Set([0])], diff)
        XCTAssertEqual([Set([0]), Set([0, 1, 2]), Set([0])], g2.findLevelsDiffUp(other: g1))
        XCTAssertFalse(g1 == g2)

        g2 = GOESP.build(str: "AACCCA")
        diff = g1.findLevelsDiffUp(other: g2)
        XCTAssertEqual([Set<Int>(), Set(), Set()], diff)
        XCTAssertEqual([Set<Int>(), Set(), Set()], g2.findLevelsDiffUp(other: g1))
        XCTAssertTrue(g1 == g2)
    }
}

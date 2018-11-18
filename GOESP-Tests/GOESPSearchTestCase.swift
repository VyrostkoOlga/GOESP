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
        XCTAssertEqual([0, 1, 4], grammar.search(substring: "AA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([2], grammar.search(substring: "AC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([5], grammar.search(substring: "AB", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([6], grammar.search(substring: "BA", nodeSelectHandler: nodeDidSelect(level:symbol:)))

        XCTAssertEqual([0, 2, 5, 7, 9], grammar2.search(substring: "CA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        
    }

    func testSearch3Mer() {
        XCTAssertEqual([3], grammar.search(substring: "CAA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([5], grammar.search(substring: "ABA", nodeSelectHandler: nodeDidSelect(level:symbol:)))

        XCTAssertEqual([0, 5, 7], grammar2.search(substring: "CAC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testSearchEqual() {
        XCTAssertEqual([0], grammar2.search(substring: "CACABCACACA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testSearchOnRandomStrings() {
        let alph = ["A", "C", "G", "T"]
        let grammar = GOESP()
        var str = ""
        for _ in 0..<5000 {
            let randIdx = Int(arc4random_uniform(UInt32(UInt(alph.count))))
            grammar.append(symbol: alph[randIdx])
            str.append(alph[randIdx])

            let substr = "AC"
            XCTAssertEqual(str.indicesOf(string: substr), grammar.search(substring: substr, nodeSelectHandler: nodeDidSelect(level:symbol:)))
        }
    }

    func testRepetitionString() {
        let str = "ACACACACACAC"
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(str, grammar.product())
        XCTAssertEqual(str.indicesOf(string: "AC"), grammar.search(substring: "AC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testRepetitionString2() {
        let str = "ACCCCACCCCAAAAACCAAACCAAA"
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(str, grammar.product())
        XCTAssertEqual(str.indicesOf(string: "AAC"), grammar.search(substring: "AAC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testRepetitionString3() {
        let str = "AAAAA"
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(str, grammar.product())
        XCTAssertEqual(str.indicesOf(string: "AA"), grammar.search(substring: "AA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testRepetitionString4() {
        let str = "CCAAAACCCCACCCACA"
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(str, grammar.product())
        XCTAssertEqual(str.indicesOf(string: "AA"), grammar.search(substring: "AA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func nodeDidSelect(level: Int, symbol: Int) {
        //print("Move to \(level), \(symbol)")
    }
}

private let grammar = GOESP.build(str: "AAACAABA")
private let grammar2 = GOESP.build(str: "CACABCACACA")

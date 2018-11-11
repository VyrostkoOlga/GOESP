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
        XCTAssertEqual([0, 1, 4], grammar.searchDeep2(substring: "AA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([2], grammar.searchDeep2(substring: "AC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([5], grammar.searchDeep2(substring: "AB", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([6], grammar.searchDeep2(substring: "BA", nodeSelectHandler: nodeDidSelect(level:symbol:)))

        XCTAssertEqual([0, 2, 5, 7, 9], grammar2.searchDeep2(substring: "CA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        
    }

    func testSearch3Mer() {
        XCTAssertEqual([3], grammar.searchDeep2(substring: "CAA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        XCTAssertEqual([5], grammar.searchDeep2(substring: "ABA", nodeSelectHandler: nodeDidSelect(level:symbol:)))

        XCTAssertEqual([0, 5, 7], grammar2.searchDeep2(substring: "CAC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testSearchEqual() {
        XCTAssertEqual([0], grammar2.searchDeep2(substring: "CACABCACACA", nodeSelectHandler: nodeDidSelect(level:symbol:)))
    }

    func testSearchOnRandomStrings() {
        let alph = ["A", "C"]
        let grammar = GOESP()
        var str = ""
        for _ in 0..<150 {
            let randIdx = Int(arc4random_uniform(UInt32(UInt(alph.count))))
            grammar.append(symbol: alph[randIdx])
            str.append(alph[randIdx])

            let substr = "AAC"
            if str.indicesOf(string: substr) != grammar.searchDeep2(substring: substr, nodeSelectHandler: nodeDidSelect(level:symbol:)) {
                print(str)
            }
        }
    }

    func testString() {
        //let str = "ACCAACCCCACCAACAAAACAACA"
        let str = "ACACACACACAC"
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(str, grammar.product())
        print(grammar.searchDeep2(substring: "AC", nodeSelectHandler: nodeDidSelect(level:symbol:)))
        print(str.indicesOf(string: "AC"))
    }

    func nodeDidSelect(level: Int, symbol: Int) {
        //print("Move to \(level), \(symbol)")
    }
}

private let grammar = GOESP.build(str: "AAACAABA")
private let grammar2 = GOESP.build(str: "CACABCACACA")

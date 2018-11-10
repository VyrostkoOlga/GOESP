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

    func testSearch3Mer() {
        XCTAssertEqual([3], grammar.searchDeep2(substring: "CAA"))
        XCTAssertEqual([5], grammar.searchDeep2(substring: "ABA"))

        XCTAssertEqual([0, 5, 7], grammar2.searchDeep2(substring: "CAC"))
    }

    func testSearchEqual() {
        XCTAssertEqual([0], grammar2.searchDeep2(substring: "CACABCACACA"))
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
            if str.indicesOf(string: substr) != grammar.searchDeep2(substring: substr) {
                print(str)
            }
        }
    }

    func testString() {
        let str = "ACCACACCAACC"
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(str, grammar.product())
        print(grammar.searchDeep2(substring: "AAC"))
        print(str.indicesOf(string: "AAC"))

    }
}

private let grammar = GOESP.build(str: "AAACAABA")
private let grammar2 = GOESP.build(str: "CACABCACACA")

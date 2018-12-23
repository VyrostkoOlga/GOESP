//
//  EmbeddingsTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 01/12/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class EmbeddingsTestCase: XCTestCase {
    func testSearch2Mer() {
        XCTAssertEqual([0, 1, 4], grammar.searchDeep2(substring: "AA"))
        XCTAssertEqual([2], grammar.searchDeep2(substring: "AC"))
        XCTAssertEqual([5], grammar.searchDeep2(substring: "AB"))
        XCTAssertEqual([6],  grammar.searchDeep2(substring: "BA"))

        //XCTAssertEqual([0, 2, 5, 7, 9], grammar2.searchDeep2(substring: "CA"))
    }

    func testSearchOnRandomStrings() {
        let alph = ["A", "C", "G", "T"]
        let grammar = GOESP()
        var str = ""
        for _ in 0..<500 {
            let randIdx = Int(arc4random_uniform(UInt32(UInt(alph.count))))
            grammar.append(symbol: alph[randIdx])
            str.append(alph[randIdx])

            ["AC"].forEach {
                print("\(str.count)")
                print(str)
                XCTAssertEqual(str.indicesOf(string: $0), grammar.searchDeep2(substring: $0))
            }
        }
    }
}

private let grammar = GOESP.build(str: "AAACAABA")
private let grammar2 = GOESP.build(str: "CACABCACACA")

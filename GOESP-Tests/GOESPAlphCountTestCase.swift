//
//  GOESPAlphCountTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 18/11/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class GOESPAlphCountTestCase: XCTestCase {
    func testCountBase() {
        check(str: "ABC", count: [1, 1, 1])
        check(str: "AACA", count: [3, 1])
        check(str: "AAC", count: [2, 1])
        check(str: "CAA", count: [1, 2])
    }

    func testCountRandomStrings() {
        let alph = ["A", "C", "G", "T"]
        let grammar = GOESP.build(str: "ACGT")
        var count = alph.map { _ in 1 }
        for _ in 0..<5000 {
            let randIdx = Int(arc4random_uniform(UInt32(UInt(alph.count))))
            grammar.append(symbol: alph[randIdx])
            count[randIdx] += 1
            XCTAssertEqual(count, grammar.countSymbols(nodeSelectionHandler: { (symbol, level) in
                // print
            }))
        }
    }

    private func check(str: String, count: [Int]) {
        let grammar = GOESP.build(str: str)
        XCTAssertEqual(count, grammar.countSymbols(nodeSelectionHandler: { (symbol, level) in
            // print
        }))
    }
}

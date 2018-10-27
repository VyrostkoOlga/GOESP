//
//  GOESPTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 07.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class GOESPTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testAxiomOnly() {
        let grammar = GOESP()
        grammar.append(symbol: "A")
        XCTAssertEqual([[0]], grammar.queues)
        XCTAssertEqual(["A"], grammar.alph)
        XCTAssertEqual("A", grammar.product())
    }

    func testEvenString() {
        let str = "AACAA"
        let grammar = GOESP()
        for symbol in str {
            grammar.append(symbol: String(symbol))
        }
        XCTAssertEqual([[0, 0, 1, 0, 0], [0, 1], [0]], grammar.queues)
        XCTAssertEqual(["A", "C"], grammar.alph)
        XCTAssertEqual(str, grammar.product())
    }

    func testOneLetterString() {
        let str = "A"
        let grammar = GOESP()
        for count in 1..<200 {
            print(count)
            grammar.append(symbol: str)
            let log = log2(Double(count))
            let ceil_log = Int(floor(log)) + 1
            XCTAssertEqual(ceil_log, grammar.queues.count)
            XCTAssertEqual(count, grammar.product().count)
            XCTAssertEqual(["A"], grammar.alph)
        }
    }

    func testRandomLettersString() {
        let alph = ["A", "C", "T", "G"]
        let grammar = GOESP()
        var str = ""
        for count in 1..<2000000 {
            let rand = Int(arc4random_uniform(UInt32(alph.count)))
            str.append(alph[rand])
            grammar.append(symbol: alph[rand])
            print("\(count) -> \(grammar.count)")
            print(Double(grammar.count) / count)
            XCTAssertEqual(str, grammar.product())
        }
    }
}

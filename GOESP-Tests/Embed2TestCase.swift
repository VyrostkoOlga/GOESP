//
//  Embed2TestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 24/11/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class Embed2TestCase: XCTestCase {
    func testEmbedToNextLevelBase() {
        let grammar = GOESP.build(str: "ABABAABBABABACA")
        XCTAssertEqual([0, 1], grammar.embedToNextLevel(current: [0, 1, 0, 0], level: 0))
        XCTAssertEqual([0, 0, 0], grammar.embedToNextLevel(current: [1, 0, 1, 0], level: 0))
        XCTAssertEqual([0, 1], grammar.embedToNextLevel(current: [0, 1], level: 1))
        XCTAssertEqual([0], grammar.embedToNextLevel(current: [0, 1], level: 2))
    }

    func testEmbedComplex() {
        let grammar = GOESP.build(str: "ABABAABBABABACA")
        XCTAssertEqual([[0, 1, 0, 0], [0, 1], [0, 1], [0]], grammar.embed(substring: "ABAA"))
        XCTAssertEqual([[1, 0, 1, 0], [0, 0, 0], [0, 0], []], grammar.embed(substring: "BABA"))
        XCTAssertEqual([[1, 1, 0], [2, 0], [1, 0], [0, 0], []], grammar.embed(substring: "BBA"))
    }

    func testEmbedAll() {
        let grammar = GOESP.build(str: "ABABAABBABABACA")
        print(grammar.embedAll(substring: "ABAA"))
        print(grammar.embedAll(substring: "BABA"))
    }
}

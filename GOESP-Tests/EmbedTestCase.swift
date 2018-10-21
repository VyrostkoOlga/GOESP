//
//  EmbedTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 21.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class EmbedTestCase: XCTestCase {

    func testEmbedTwoLetterString() {
        var embedding = grammar.embed(str: "CA")
        XCTAssertEqual([GOESP.StackElement(symbol: 1, level: 1)], embedding!)
        embedding = grammar.embed(str: "AC")
        XCTAssertEqual([GOESP.StackElement(symbol: 2, level: 1)], embedding!)
        embedding = grammar.embed(str: "AT")
        XCTAssertNil(embedding)
    }

    func testEmbedThreeLetterString() {
        var embedding = grammar.embed(str: "CAA")
        XCTAssertEqual([GOESP.StackElement(symbol: 1, level: 1), GOESP.StackElement(symbol: 0, level: 0)], embedding!)
        embedding = grammar.embed(str: "CTA")
        XCTAssertNil(embedding)
    }

    func testEmbedFourLetterString() {
        var embedding = grammar.embed(str: "CAAC")
        XCTAssertEqual([GOESP.StackElement(symbol: 0, level: 2)], embedding!)
        //embedding = grammar.embed(str: "CTA")
        //XCTAssertNil(embedding)
    }
}


/**
 [0, 0, 1, 0, 0, 1, 2, 0]
 [0, 1, 2, 3, 2]
 [0, 1]
 [0]
 */
private let grammar = GOESP.build(str: "AACAACTAACAA")

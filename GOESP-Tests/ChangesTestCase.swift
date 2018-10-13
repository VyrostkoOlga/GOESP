//
//  ChangesTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 13.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class ChangesTestCase: XCTestCase {

    /**
     Main goal is to understand how tree changes when one or two letters change
    */
    func testTwoLetterAlph6Mer() {
        checkOneLetterMutation(alph: ["A", "C"], strLen: 6)
    }

    func testFourLetterAlph6Mer() {
        checkOneLetterMutation(alph: ["A", "C", "G", "T"], strLen: 6)
    }

    func testFourLetterAlph10Mer() {
        checkOneLetterMutation(alph: ["A", "C", "G", "T"], strLen: 10)
    }
}

private extension ChangesTestCase {
    func checkOneLetterMutation(alph: [String], strLen: Int) {
        let startString = String(alph: alph, len: strLen)
        print(startString)
        print(GOESP.build(str: startString))
        print("---------")
        for i in 0..<strLen {
            let index = startString.index(startString.startIndex, offsetBy: i)
            alph.forEach {
                let str = startString.replacingCharacters(in: index...index, with: $0)
                print(str)
                print(GOESP.build(str: str))
                print("---------")
            }
        }
    }

    func checkString(_ str: String) {
        let grammar = GOESP()
        str.forEach {
            grammar.append(symbol: String($0))
        }
        grammar.queues.forEach { print($0) }
    }
}

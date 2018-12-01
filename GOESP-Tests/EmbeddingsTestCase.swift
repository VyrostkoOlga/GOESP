//
//  EmbeddingsTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 01/12/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class EmbeddingsTestCase: XCTestCase {
    func testEmbeddingsBase() {
        let grammar = GOESP.build(str: "AAAA")
        grammar.searchDeep2(substring: "AA")
    }
}

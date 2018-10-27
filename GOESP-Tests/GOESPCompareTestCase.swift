//
//  GOESPCompareTestCase.swift
//  GOESP-Tests
//
//  Created by Olga Vyrostko on 27/10/2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import XCTest

final class GOESPCompareTestCase: XCTestCase {

    func testCompareBasic() {
        let g1 = GOESP.build(str: "AACCCA")
        let g2 = GOESP.build(str: "AACACA")
        print(g1)
        print(g2)
        let diff = g1.findLevelsDiffUp(other: g2)
    }

}

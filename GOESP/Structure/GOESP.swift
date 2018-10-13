//
//  GOESP.swift
//  GOESP
//
//  Created by Olga Vyrostko on 07.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import Foundation

final class GOESP {
    private(set) var queues = [[Int]]()
    private(set) var alph = [String]()

    func append(symbol: String) {
        let rule: Int
        if let idx = alph.firstIndex(of: symbol) {
            rule = idx
        } else {
            rule = alph.count
            alph.append(symbol)
        }
        append(symbol: rule, to: 0)
    }

    func product() -> String {
        var queue = [Int]()
        var nqueue = [Int]()
        queues.last?.forEach { queue.append($0) }
        for idx in 1..<queues.count {
            let queueIdx = queues.count - idx
            for symbol in queue {
                nqueue.append(queues[queueIdx - 1][symbol * 2])
                nqueue.append(queues[queueIdx - 1][symbol * 2 + 1])
            }
            if queues[queueIdx - 1].count & 1 == 1 {
                nqueue.append(queues[queueIdx - 1].last!)
            }
            queue = nqueue
            nqueue = [Int]()
        }
        return queue.map { alph[$0] }.joined()
    }
}

private extension GOESP {
    func append(symbol: Int, to queueIdx: Int) {
        guard queueIdx < queues.count else {
            queues.append([symbol])
            return
        }
        let count = queues[queueIdx].count
        guard count & 1 == 1 else {
            queues[queueIdx].append(symbol)
            return
        }
        let prevSymbol = queues[queueIdx].popLast()!
        let rule: Int
        if let frule = self.rule(left: prevSymbol, right: symbol, in: queueIdx) {
            rule = frule
        } else {
            if queueIdx + 1 < queues.count, let max = queues[queueIdx + 1].max() {
                rule = max + 1
            } else {
                rule = 0
            }
            queues[queueIdx].append(prevSymbol)
            queues[queueIdx].append(symbol)
        }
        append(symbol: rule, to: queueIdx + 1)
    }

    func rule(left: Int, right: Int, in queueIdx: Int) -> Int? {
        guard queueIdx < queues.count else {
            return nil
        }
        let queue = queues[queueIdx]
        let count = queue.count / 2
        guard count >= 0 else {
            return nil
        }
        for i in 0..<count {
            let idx = i * 2
            if queue[idx] == left, queue[idx + 1] == right {
                return i
            }
        }
        return nil
    }
}

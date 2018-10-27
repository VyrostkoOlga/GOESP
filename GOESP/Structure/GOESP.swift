//
//  GOESP.swift
//  GOESP
//
//  Created by Olga Vyrostko on 07.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import Foundation

final class GOESP {
    struct StackElement: Equatable {
        typealias This = StackElement

        let symbol: Int
        let level: Int

        static func == (lhs: This, rhs: This) -> Bool {
            return lhs.symbol == rhs.symbol && lhs.level == rhs.level
        }
    }

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

extension GOESP: CustomDebugStringConvertible {
    var debugDescription: String {
        return queues.map { "\($0)" }.joined(separator: "\n")
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

extension GOESP {
    static func build(str: String) -> GOESP {
        let grammar = GOESP()
        str.forEach {
            grammar.append(symbol: String($0))
        }
        return grammar
    }
}

// MARK: - search

extension GOESP {
    /**
     Creates an embedding of substring to a grammar if it's possible
     */
    func embed(str: String) -> [StackElement]? {
        if str.isEmpty { return nil }
        var stack = [StackElement]()
        for symbol in str {
            guard let alphSymbol = alph.firstIndex(of: String(symbol)) else {
                return nil
            }
            stack.append(StackElement(symbol: alphSymbol, level: 0))
            while stack.count >= 2, stack[stack.count - 2].level == stack[stack.count - 1].level {
                let right = stack.popLast()!
                let left = stack.popLast()!
                guard let symbol = rule(
                    left: left.symbol,
                    right: right.symbol,
                    in: left.level
                ) else {
                    return stack + [left, right]
                }
                stack.append(StackElement(symbol: symbol, level: left.level + 1))
            }
        }
        return stack
    }
}

// MARK: - compare

extension GOESP {
    /**
     Iterate on levels and find differences for each level
     For example:
     grammar 1: [0, 0, 1, 1, 1, 0], [0, 1, 2], [0]
     grammar 2: [0, 0, 1, 0], [0, 1, 1], [0]
     diff: [3, 4, 5], [1, 2], []
    */
    func findLevelsDiffUp(other: GOESP) -> [[Int]] {
        var idx = 0
        var diff = [[Int]]()
        var prevDiff = Set<Int>()
        while idx < queues.count {
            let q1 = queues[idx]
            let q2 = other.queues[idx]
            let border = min(q1.count, q2.count) / 2
            var curDiff = [Int]()
            for i in 0..<border {
                var el = q1[i * 2]
                if el != q2[i * 2] || prevDiff.contains(where: { $0 == el * 2 || $0 == el * 2 + 1 }) {
                    curDiff.append(i * 2)
                }
                el = q1[i * 2 + 1]
                if el != q2[i * 2 + 1] || prevDiff.contains(where: { $0 == el * 2 || $0 == el * 2 + 1 }) {
                    curDiff.append(i * 2 + 1)
                }
            }
            let bound = border * 2
            if q1.count == q2.count {
                for i in bound..<q1.count {
                    if q1[i] != q2[i] || prevDiff.contains(q1[i] * 2) {
                        curDiff.append(i)
                    }
                }
            } else {
                if bound + 1 < q1.count {
                    for i in bound..<q1.count {
                        curDiff.append(i)
                    }
                }
                if bound + 1 < q2.count {
                    for i in bound..<q2.count {
                        curDiff.append(i)
                    }
                }
            }
            diff.append(curDiff)
            prevDiff = Set(curDiff)
            idx += 1
        }
        return diff
    }
}

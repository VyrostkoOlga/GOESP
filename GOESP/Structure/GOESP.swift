//
//  GOESP.swift
//  GOESP
//
//  Created by Olga Vyrostko on 07.10.2018.
//  Copyright © 2018 olgavyrostko. All rights reserved.
//

import Foundation

final class GOESP {
    struct StackElement: Equatable, Hashable {
        typealias This = StackElement

        let symbol: Int
        let level: Int

        static func == (lhs: This, rhs: This) -> Bool {
            return lhs.symbol == rhs.symbol && lhs.level == rhs.level
        }

        var hashValue: Int {
            return symbol << level
        }
    }

    struct Node: Equatable, Hashable {
        typealias This = Node

        /*
         Example:
         0
         000
         00
         01
         For the left child of 0 in the third place in the third queue, coordinates
         will be symbol = 0, level = 1, pos = 4
        */
        let symbol: Int     // position of symbol in queue
        let level: Int      // level of the queue
        let pos: Int        // real position in queue

        static func == (lhs: This, rhs: This) -> Bool {
            return lhs.pos == rhs.pos && lhs.level == rhs.level
        }

        var hashValue: Int {
            return pos << level
        }
    }

    private(set) var queues = [[Int]]()
    private(set) var alph = [String]()

    var count: Int {
        var count = 0
        queues.forEach { count += $0.count }
        return count
    }

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

    func rule(left: Int?, right: Int?, in queueIdx: Int) -> Int? {
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
            if queue[idx] == left, nil == right {
                return i
            }
            if queue[idx + 1] == right, nil == left {
                return i
            }
        }
        return nil
    }

    func rules(left: Int?, right: Int?, in queueIdx: Int) -> [Int] {
        guard queueIdx < queues.count else {
            return []
        }
        let queue = queues[queueIdx]
        let count = queue.count / 2
        guard count >= 0 else {
            return []
        }
        var result = [Int]()
        for i in 0..<count {
            let idx = i * 2
            if queue[idx] == left, queue[idx + 1] == right {
                result.append(i)
                continue
            }
            if queue[idx] == left, nil == right {
                result.append(i)
                continue
            }
            if queue[idx + 1] == right, nil == left {
                result.append(i)
                continue
            }
        }
        return result
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

extension GOESP: Equatable {
    static func == (lhs: GOESP, rhs: GOESP) -> Bool {
        let diff = lhs.findLevelsDiffUp(other: rhs)
        let notEmptyDiff = nil != diff.first(where: { !$0.isEmpty })
        return lhs.queues.count == rhs.queues.count && !notEmptyDiff
    }

    /**
     Iterate on levels and find differences for each level
     For example:
     grammar 1: [0, 0, 1, 1, 1, 0], [0, 1, 2], [0]
     grammar 2: [0, 0, 1, 0], [0, 1, 1], [0]
     diff: [3, 4, 5], [1, 2], [0]
    */
    func findLevelsDiffUp(other: GOESP) -> [Set<Int>] {
        var idx = 0
        let border = min(queues[idx].count, other.queues[idx].count)
        var curDiff = Set<Int>()
        for i in 0..<border {
            let el2 = mapAlph(symbol: other.queues[idx][i], grammar: other)
            if queues[idx][i] != el2 {
                curDiff.insert(i)
            }
        }
        idx += 1
        var diff = [curDiff]

        var prevDiff = curDiff
        let minNumberOfQueues = min(queues.count, other.queues.count)
        while idx < minNumberOfQueues {
            let q1 = queues[idx]
            let q2 = other.queues[idx]
            let border = min(q1.count, q2.count) / 2
            curDiff = Set<Int>()
            for i in 0..<border {
                var el = q1[i * 2]
                if el != q2[i * 2] || prevDiff.contains(where: { $0 == el * 2 || $0 == el * 2 + 1 }) {
                    curDiff.insert(i * 2)
                }
                el = q1[i * 2 + 1]
                if el != q2[i * 2 + 1] || prevDiff.contains(where: { $0 == el * 2 || $0 == el * 2 + 1 }) {
                    curDiff.insert(i * 2 + 1)
                }
            }
            let bound = border * 2
            if q1.count == q2.count {
                for i in bound..<q1.count {
                    if q1[i] != q2[i] || prevDiff.contains(where: { $0 == q1[i] * 2 || $0 == q2[i] * 2 + 1 }) {
                        curDiff.insert(i)
                    }
                }
            }
            diff.append(curDiff)
            prevDiff = curDiff
            idx += 1
        }
        return diff
    }

    /**
     Map symbol of other grammar's alph to a current grammar alph.
     f.e. alph1 = [A, C] and A = 0
          alph2 = [C, A] and A = 1,
     then function for A and grammar2 returns 0
    */
    private func mapAlph(symbol: Int, grammar: GOESP) -> Int? {
        return alph.firstIndex(of: grammar.alph[symbol])
    }
}

// MARK: - search v2
extension GOESP {
    func search(substring: String) {
        var innerSubstring = [Int]()
        for symb in substring {
            guard let innerSymbol = alph.firstIndex(of: String(symb)) else {
                // mismatch
                return
            }
            innerSubstring.append(innerSymbol)
        }
        guard let firstSymbol = innerSubstring.first else {
            // empty string - found
            return
        }
        guard let firstQueue = queues.first else {
            // empty tree - mismatch
            return
        }
        var idx = 0
        while idx < firstQueue.count {
            if firstQueue[idx] == firstSymbol {
                print(match(substr: innerSubstring, from: idx))
            }
            idx += 1
        }
    }

    private func match(substr: [Int], from startPos: Int) -> Bool {
        var currentPos = startPos
        var currentLevel = 0
        var idx = 0
        while idx < substr.count {
            // step 1: compare current
            guard queues[currentLevel][currentPos] == substr[idx] else {
                return false
            }

            // step 2: determine if current position is left node or
            // right node of the rule
            if currentPos & 1 == 0 {
                // if left, move to right - move to next right
                // item in current queue
                if currentPos + 1 == queues[currentLevel].count {
                    return false
                }
                currentPos += 1
                idx += 1
                continue
            }

            // if right, should move to next item in level up queue and then
            // to its left child
            currentLevel += 1
            guard currentLevel < queues.count else {
                // mismatch
                return false
            }
            currentPos = (currentPos - 1) / 2
            guard currentPos + 1 < queues[currentLevel].count else {
                // mismatch
                return false
            }
            currentPos = currentPos + 1
            currentLevel -= 1
            currentPos = currentPos * 2
            idx += 1
        }
        return true
    }
}

// MARK: - search v3
extension GOESP {
    private final class Match: Equatable, Hashable, CustomDebugStringConvertible {
        let position: Int
        var idx: Int
        var distance: Int

        var embedding: [Node]

        init(position: Int, node: Node? = nil) {
            self.position = position
            self.idx = 0
            self.distance = 0
            self.embedding = []
            if let node = node {
                embedding.append(node)
            }
        }

        static func ==(lhs: Match, rhs: Match) -> Bool {
            return lhs.position == rhs.position
        }

        var hashValue: Int {
            return position
        }

        var debugDescription: String {
            return "\(position) \(idx)"
        }

        func append(node: Node) {
            embedding.append(node)
        }

        func replaceLastTwo(node: Node) {
            for _ in 0..<2 {
                if !embedding.isEmpty {
                    _ = embedding.popLast()
                }
            }
            embedding.append(node)
        }
    }

    func searchDeep(substring: String) -> [Int] {
        var innerSubstring = [Int]()
        for symb in substring {
            guard let innerSymbol = alph.firstIndex(of: String(symb)) else {
                // mismatch
                return []
            }
            innerSubstring.append(innerSymbol)
        }

        // start with the most deep, the most left
        var currentPos = 0
        var currentLevel = 0
        var foundMatches = [Int]()
        var matches = [Match]()
        var idx = 0
        var path = [StackElement]()
        while true {
            // step 1: check if still matches
            var toRemove = Set<Match>()
            let currentSymbol = queues[currentLevel][currentPos]
            if currentLevel == 0 {
                matches.forEach {
                    if $0.idx == substring.count - 1 {
                        // match
                        foundMatches.append($0.position)
                        toRemove.insert($0)
                    } else if currentSymbol != innerSubstring[$0.idx + 1] {
                        toRemove.insert($0)
                    } else {
                        $0.idx += 1
                    }
                }
                matches.removeAll(where: { toRemove.contains($0) })

                // step 2: check if current symbol is a start of a new match
                if innerSubstring[0] == currentSymbol {
                    matches.append(Match(position: idx))
                }
                idx += 1
            }

            // step 3: move
            // if current position is even, should move to
            // the next right node in current queue (right sibling of
            // current node)
            if currentPos & 1 == 0 {
                // move right
                if currentPos + 1 >= queues[currentLevel].count {
                    break
                }
                currentPos += 1
                print("Move to \(currentLevel) \(currentPos)")
                continue
            }

            if let pathElement = path.popLast() {
                currentPos = pathElement.symbol
                currentLevel = pathElement.level
                print("Move to \(currentLevel) \(currentPos)")
                continue
            }

            while currentPos & 1 == 1 {
                if currentLevel + 1 >= queues.count {
                    break
                }
                currentLevel += 1
                currentPos = (currentPos - 1) >> 1
                print("Move to \(currentLevel) \(currentPos)")
            }
            currentPos += 1
            while currentLevel > 0 {
                let currentParent = queues[currentLevel][currentPos]
                path.append(StackElement(symbol: currentPos, level: currentLevel))
                currentPos = queues[currentLevel].firstIndex(of: currentParent)! << 1
                currentLevel -= 1
            }
            print("Move to \(currentLevel) \(currentPos)")
        }
        return foundMatches + matches.compactMap { $0.idx == substring.count - 1 ? $0.position : nil }
    }
}

extension GOESP {
    func search(substring: String, distance: Int = 0, nodeSelectHandler: (Int, Int) -> Void) -> [Int] {
        // map to internal symbols
        var innerSubstring = [Int]()
        for symb in substring {
            guard let innerSymbol = alph.firstIndex(of: String(symb)) else {
                // mismatch
                return []
            }
            innerSubstring.append(innerSymbol)
        }

        var foundMatches = [Int]()
        var matches = [Match]()
        searchDeep2(action: { (symbol, idx) in
            var toRemove = Set<Match>()
            matches.forEach {
                if $0.idx == substring.count - 1 {
                    // match
                    foundMatches.append($0.position)
                    toRemove.insert($0)
                } else if symbol != innerSubstring[$0.idx + 1] {
                    // distance should be increased
                    $0.distance += 1
                    $0.idx += 1
                    // if distance from pattern is greater than desired
                    // mismatch, should be removed
                    if $0.distance > distance {
                        toRemove.insert($0)
                    }
                } else {
                    // still match, increase number of matching symbols
                    $0.idx += 1
                }
            }
            matches.removeAll(where: { toRemove.contains($0) })

            // step 2: check if current symbol is a start of a new match
            if innerSubstring[0] == symbol {
                matches.append(Match(position: idx))
            } else if distance > 0 {
                let match = Match(position: idx)
                match.distance = 1
                matches.append(match)
            }
        }, nodeSelectHandler: nodeSelectHandler)
        foundMatches.append(contentsOf: matches.compactMap { $0.idx == innerSubstring.count - 1 ? $0.position : nil })
        return foundMatches
    }

    func countSymbols(nodeSelectionHandler: (Int, Int) -> Void) -> [Int] {
        var alphCount = alph.map { _ in 0 }
        searchDeep2(action: { (symbol, _) in
            alphCount[symbol] += 1
        }, nodeSelectHandler: nodeSelectionHandler)
        return alphCount
    }
}

private extension GOESP {
    func searchDeep2(action: (Int, Int) -> Void, nodeSelectHandler: (Int, Int) -> Void) {
        var visited = Set<Node>()
        var stack = [Node(symbol: 0, level: 0, pos: 0)] // start with the most left, the lowest
        var idx = 0

        while !stack.isEmpty {
            let current = stack.popLast()!
            nodeSelectHandler(current.level, current.symbol)
            visited.insert(current)

            let currentSymbol = queues[current.level][current.symbol]

            // step 1: when travel throught the lowest level,
            // check for all matches if still matches
            if current.level == 0 {
                action(currentSymbol, idx)
                idx += 1
            }

            // step 3: moving
            if current.level > 0 {
                // if could move to left child, move down
                let childNode = Node(symbol: currentSymbol << 1, level: current.level - 1, pos: current.pos << 1)
                if !visited.contains(childNode) {
                    visited.insert(childNode)
                    stack.append(current)
                    stack.append(childNode)
                    continue
                }
            }

            if current.symbol & 1 == 0, queues[current.level].count > current.symbol + 1 {
                // if could move to right sibling, move right
                let rightNode = Node(symbol: current.symbol + 1, level: current.level, pos: current.pos + 1)
                stack.append(rightNode)
                continue
            }

            if current.level < queues.count - 1 {
                let parentSymbol = current.pos >> 1
                let parentNode = Node(symbol: parentSymbol, level: current.level + 1, pos: parentSymbol)
                if !visited.contains(parentNode), parentNode.symbol < queues[parentNode.level].count {
                    stack.append(parentNode)
                }
            }
        }

        // the most right
        var queueIdx = queues.count - 2
        var currentLevel = [Int]()
        var nextLevel = [Int]()
        while queueIdx >= 0 {
            nextLevel = []
            currentLevel.forEach {
                nextLevel.append(queues[queueIdx][$0 << 1])
                nextLevel.append(queues[queueIdx][$0 << 1 + 1])
            }
            // extra symbol
            if queues[queueIdx].count & 1 == 1 {
                nextLevel.append(queues[queueIdx].last!)
            }
            currentLevel = nextLevel
            queueIdx -= 1
        }
        for symbol in currentLevel {
            action(symbol, idx)
            idx += 1
        }
    }
}

extension GOESP {
    typealias Embedding = [[Int]]

    func embedToNextLevel(current: [Int], level: Int) -> [Int] {
        var result = mapToNextLevel(current: current, level: level, startIdx: 0)
        guard result.isEmpty else {
            return result
        }
        guard let firstRule = self.rule(left: nil, right: current[0], in: level) else {
            return result
        }
        result.append(firstRule)
        let resultSuffux = mapToNextLevel(current: current, level: level, startIdx: 1)
        guard !resultSuffux.isEmpty else {
            return []
        }
        result += resultSuffux
        return result
    }

    private func mapToNextLevel(current: [Int], level: Int, startIdx: Int) -> [Int] {
        var idx = startIdx
        var result = [Int]()
        while idx < current.count - 1 {
            let left = current[idx]
            let right = current[idx + 1]
            if let rule = self.rule(left: left, right: right, in: level) {
                result.append(rule)
            } else {
                return []
            }
            idx += 2
        }
        guard (current.count - startIdx) & 1 == 1 else {
            return result
        }
        guard let lastRule = self.rule(left: current.last!, right: nil, in: level) else {
            return []
        }
        result.append(lastRule)
        return result
    }

    func embed(substring: String) -> Embedding? {
        var result = [[Int]]()
        result.append([])
        for symbol in substring {
            guard let alphSymbol = alph.firstIndex(of: String(symbol)) else {
                return nil
            }
            result[0].append(alphSymbol)
        }
        var level = 0
        while result[level].count > 1 {
            result.append(embedToNextLevel(current: result[level], level: level))
            level += 1
        }
        return result
    }
}

extension GOESP {
    func embedAll(substring: String) -> [Embedding] {
        var result = [Embedding]()
        var innerString = [Int]()
        for symbol in substring {
            guard let alphSymbol = alph.firstIndex(of: String(symbol)) else {
                return []
            }
            innerString.append(alphSymbol)
        }
        result.append([innerString])

        var level = 0
        while nil != result.first(where: { $0.last!.count > 1}) {
            var newResult = [Embedding]()
            result.forEach {
                let next = embedToNextLevelAll(current: $0.last!, level: level)
                guard !next.isEmpty else {
                    return
                }
                for nextLevel in next {
                    newResult.append($0 + [nextLevel])
                }
            }
            result = newResult
            level += 1
        }
        return result
    }

    func embedToNextLevelAll(current: [Int], level: Int) -> [[Int]] {
        var result = mapToNextLevelAll(current: current, level: level, startIdx: 0)
        let firstRules = self.rules(left: nil, right: current[0], in: level)
        guard !firstRules.isEmpty else {
            return result
        }
        let resultSuffuxes = mapToNextLevelAll(current: current, level: level, startIdx: 1)
        guard !resultSuffuxes.isEmpty else {
            return result
        }
        firstRules.forEach { rule in
            resultSuffuxes.forEach { suffix in
                result.append([rule] + suffix)
            }
        }
        return result
    }

    private func mapToNextLevelAll(current: [Int], level: Int, startIdx: Int) -> [[Int]] {
        var idx = startIdx
        var result = [[Int]]()
        var currentResult = [Int]()
        while idx < current.count - 1 {
            let left = current[idx]
            let right = current[idx + 1]
            if let rule = self.rule(left: left, right: right, in: level) {
                currentResult.append(rule)
            } else {
                return []
            }
            idx += 2
        }
        guard (current.count - startIdx) & 1 == 1 else {
            return [currentResult]
        }
        let lastRules = self.rules(left: current.last!, right: nil, in: level)
        guard !lastRules.isEmpty else {
            return []
        }
        lastRules.forEach {
            let newResult = currentResult + [$0]
            result.append(newResult)
        }
        return result
    }
}

extension GOESP {
    typealias Embedding2 = [Node2]

    final class Match2: Equatable, Hashable {
        let index: Int              // index of match
        var offset: Int             // number of currently found symbols
        var embedding: Embedding2   // embedding of match to GOESP
        var distance: Int           // number of currently found not matched symbols

        init(index: Int, node: Node2) {
            self.index = index
            self.offset = 0
            self.embedding = [node]
            self.distance = 0
        }

        static func == (lhs: Match2, rhs: Match2) -> Bool {
            return lhs.index == rhs.index && lhs.offset == rhs.offset
        }

        var hashValue: Int {
            return index + offset
        }
    }

    struct Node2: Equatable, Hashable, CustomDebugStringConvertible {
        let position: Int           // position of symbol in queue
        let level: Int              // index of queue
        let offset: Int             // offset from the start of the queue

        static func == (lhs: Node2, rhs: Node2) -> Bool {
            return lhs.position == rhs.position && lhs.level == rhs.level && lhs.offset == rhs.offset
        }

        var hashValue: Int {
            return position + level
        }

        var debugDescription: String {
            return "\(offset)"
        }
    }

    func searchDeep2(substring: String, distance: Int = 0) -> [Int] {
        // map to internal symbols
        var innerSubstring = [Int]()
        for symb in substring {
            guard let innerSymbol = alph.firstIndex(of: String(symb)) else {
                // mismatch
                return []
            }
            innerSubstring.append(innerSymbol)
        }

        var foundMatches = [Int]()
        var matches = [Match2]()
        var embeddings = [Embedding2: Int]()
        let substringHeight = Int(floor(log2(Double(substring.count))))

        let action = { [weak self] (node: Node2, idx: Int) in
            guard let self = self else { return }
            let symbol = self.queues[node.level][node.position]
            var toRemove = Set<Match2>()
            matches.forEach {
                if $0.offset == substring.count - 1 {
                    // match
                    foundMatches.append($0.index)
                    toRemove.insert($0)
                    let count = embeddings[$0.embedding] ?? 0
                    embeddings[$0.embedding] = count + 1
                } else if symbol != innerSubstring[$0.offset + 1] {
                    // distance should be increased
                    $0.distance += 1
                    $0.offset += 1
                    // if distance from pattern is greater than desired
                    // mismatch, should be removed
                    if $0.distance > distance {
                        toRemove.insert($0)
                    }
                } else {
                    // still match, increase number of matching symbols
                    $0.offset += 1
                    $0.embedding.append(node)
                }
            }
            matches.removeAll(where: { toRemove.contains($0) })

            // step 2: check if current symbol is a start of a new match
            if innerSubstring[0] == symbol {
                matches.append(Match2(index: idx, node: node))
            } else if distance > 0 {
                let match = Match2(index: idx, node: node)
                match.distance = 1
                matches.append(match)
            }
        }

        var visited = Set<Node2>()
        var stack = [Node2(position: 0, level: 0, offset: 0)] // start with the most left, the lowest
        var idx = 0

        while !stack.isEmpty {
            let current = stack.popLast()!
            visited.insert(current)

            let currentSymbol = queues[current.level][current.position]

            // step 1: when travel throught the lowest level,
            // check for all matches if still matches
            if current.level == 0 {
                print(current)
                action(current, idx)
                idx += 1
            }

            // step 3: moving
            if current.level > 0 {
                // if could move to left child, move down
                let childNode = Node2(position: currentSymbol << 1, level: current.level - 1, offset: current.offset << 1)
                if !visited.contains(childNode) {
                    visited.insert(childNode)
                    stack.append(current)
                    stack.append(childNode)
                    continue
                }
            }

            if current.position & 1 == 0, queues[current.level].count > current.position + 1 {
                // if could move to right sibling, move right
                let rightNode = Node2(position: current.position + 1, level: current.level, offset: current.offset + 1)
                stack.append(rightNode)
                continue
            }

            if current.level < queues.count - 1 {
                let parentSymbol = current.offset >> 1
                let parentNode = Node2(position: parentSymbol, level: current.level + 1, offset: parentSymbol)
                if parentNode.position < queues[parentNode.level].count, !visited.contains(parentNode) {
                    stack.append(parentNode)
                }
            }
        }

        // the most right
        var queueIdx = queues.count - 2
        var currentLevel = [Int]()
        var nextLevel = [Int]()
        while queueIdx >= 0 {
            nextLevel = []
            currentLevel.forEach {
                nextLevel.append(queues[queueIdx][$0 << 1])
                nextLevel.append(queues[queueIdx][$0 << 1 + 1])
            }
            // extra symbol
            if queues[queueIdx].count & 1 == 1 {
                nextLevel.append(queues[queueIdx].last!)
            }
            currentLevel = nextLevel
            queueIdx -= 1
        }
        for symbol in currentLevel {
            action(Node2(position: symbol, level: 0, offset: idx), idx)
            idx += 1
        }
        foundMatches.append(contentsOf: matches.compactMap {
            guard $0.offset == innerSubstring.count - 1 else { return nil }
            //embeddings.insert($0.embedding)
            return $0.index
        })
        print(embeddings.count)
        print(embeddings)
        return foundMatches
    }
}


